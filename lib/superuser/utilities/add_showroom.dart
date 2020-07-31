import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/utils.dart';

class AddShowroom extends StatefulWidget {
  @override
  _AddShowroomState createState() => _AddShowroomState();
}

class _AddShowroomState extends State<AddShowroom> {
  final showrooms = Firestore.instance.collection('showrooms');
  final DocumentSnapshot docSnap = Get.arguments;
  final Map locationsMap = Controllers.to.locations.value.data;
  final Utils utils = Utils();

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
    print(docSnap);
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
      appBar: utils.appbar(docSnap == null ? 'Add Showroom' : 'Edit Showroom'),
      body: utils.container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 36),
            utils.productInputDropDown(
                label: 'State',
                value: selectedState,
                items: locationsMap.keys.toList(),
                onChanged: (value) {
                  selectedState = value;
                  selectedArea = null;
                  handleSetState();
                }),
            utils.productInputDropDown(
                label: 'Area',
                value: selectedArea,
                items: areas,
                onChanged: (newValue) {
                  selectedArea = newValue;
                  handleSetState();
                }),
            utils.inputTextField(
              label: 'Name',
              controller: titleController,
            ),
            utils.inputTextField(
              label: 'Address',
              controller: addressController,
            ),
            utils.inputTextField(
              label: 'latitude',
              controller: latitudeController,
              textInputType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            utils.inputTextField(
              label: 'longitude',
              controller: longitudeController,
              textInputType:
              TextInputType.numberWithOptions(signed: true, decimal: true),
            ),
            SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                utils.getRaisedButton(
                  title: 'Cancel',
                  onPressed: () => Get.back(),
                ),
                utils.getRaisedButton(
                  title: docSnap == null ? 'Confirm' : 'Update',
                  onPressed: () async {
                    if (titleController.text.length > 0 &&
                        addressController.text.length > 0 &&
                        latitudeController.text.length > 0 &&
                        longitudeController.text.length > 0 &&
                        selectedArea != null &&
                        selectedState != null) {
                      if (docSnap == null) {
                        showrooms.document().setData({
                          'name': titleController.text,
                          'adress': addressController.text,
                          'state': selectedState,
                          'area': selectedArea,
                          'latitude': latitudeController.text,
                          'longitude': longitudeController.text,
                        });
                      } else {
                        showrooms.document(docSnap.documentID).updateData({
                          'name': titleController.text,
                          'adress': addressController.text,
                          'state': selectedState,
                          'area': selectedArea,
                          'latitude': latitudeController.text,
                          'longitude': longitudeController.text,
                        });
                      }
                      Get.back();
                    } else {
                      utils.showSnackbar('Invalid Entries');
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
