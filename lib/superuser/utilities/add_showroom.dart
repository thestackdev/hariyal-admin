import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class AddShowroom extends StatefulWidget {
  @override
  _AddShowroomState createState() => _AddShowroomState();
}

class _AddShowroomState extends State<AddShowroom> {
  final controllers = Controllers.to;
  final DocumentSnapshot docSnap = Get.arguments;
  Map locationsMap = {};

  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  List states = [];
  List areas = [];
  String selectedState;
  String selectedArea;

  @override
  void initState() {
    locationsMap = controllers.locations.value.data;
    if (docSnap != null) {
      titleController.text = docSnap['name'];
      addressController.text = docSnap['adress'];
      latitudeController.text = docSnap['latitude'];
      longitudeController.text = docSnap['longitude'];
      selectedArea = docSnap['area'];
      selectedState = docSnap['state'];
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    addressController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedState != null) {
      areas = locationsMap[selectedState];
    }

    return Scaffold(
      appBar: controllers.utils
          .appbar(docSnap == null ? 'Add Showroom' : 'Edit Showroom'),
      body: controllers.utils.container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 36),
            controllers.utils.productInputDropDown(
                label: 'State',
                value: selectedState,
                items: locationsMap.keys.toList(),
                onChanged: (value) {
                  selectedState = value;
                  selectedArea = null;
                  handleSetState();
                }),
            controllers.utils.productInputDropDown(
                label: 'Area',
                value: selectedArea,
                items: areas,
                onChanged: (newValue) {
                  selectedArea = newValue;
                  handleSetState();
                }),
            controllers.utils.inputTextField(
              label: 'Name',
              controller: titleController,
            ),
            controllers.utils.inputTextField(
              label: 'Address',
              controller: addressController,
            ),
            controllers.utils.inputTextField(
              label: 'latitude',
              controller: latitudeController,
              textInputType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            controllers.utils.inputTextField(
              label: 'longitude',
              controller: longitudeController,
              textInputType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                controllers.utils.getRaisedButton(
                  title: 'Cancel',
                  onPressed: () => Get.back(),
                ),
                controllers.utils.getRaisedButton(
                  title: docSnap == null ? 'Confirm' : 'Update',
                  onPressed: () async {
                    if (titleController.text.length > 0 &&
                        addressController.text.length > 0 &&
                        latitudeController.text.length > 0 &&
                        longitudeController.text.length > 0 &&
                        selectedArea != null &&
                        selectedState != null) {
                      if (docSnap == null) {
                        controllers.showrooms.document().setData({
                          'name': titleController.text,
                          'address': addressController.text,
                          'state': selectedState,
                          'area': selectedArea,
                          'latitude': latitudeController.text,
                          'longitude': longitudeController.text,
                          'timestamp': DateTime.now().millisecondsSinceEpoch,
                          'active': true,
                        });
                      } else {
                        controllers.showrooms
                            .document(docSnap.documentID)
                            .updateData({
                          'name': titleController.text,
                          'address': addressController.text,
                          'state': selectedState,
                          'area': selectedArea,
                          'latitude': latitudeController.text,
                          'longitude': longitudeController.text,
                        });
                      }
                      Get.back();
                    } else {
                      controllers.utils.showSnackbar('Invalid Entries');
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  handleSetState() => (mounted) ? setState(() {}) : null;
}
