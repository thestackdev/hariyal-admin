import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class AddShowroom extends StatefulWidget {
  @override
  _AddShowroomState createState() => _AddShowroomState();
}

class _AddShowroomState extends State<AddShowroom> {
  final controllers = Controllers.to;
  final DocumentSnapshot docSnap = Get.arguments;

  final titleController = TextEditingController();
  final addressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final phoneController = TextEditingController();

  List states = [];
  List areas = [];
  String selectedState;
  String selectedArea;

  @override
  void initState() {
    if (docSnap != null) {
      titleController.text = docSnap['name'];
      addressController.text = docSnap['address'];
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
    return controllers.utils.root(
      label: docSnap == null ? 'Add Showroom' : 'Edit Showroom',
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: <Widget>[
              controllers.utils.streamBuilder<DocumentSnapshot>(
                stream: controllers.locationsStream,
                builder: (context, snapshot) =>
                    controllers.utils.productInputDropDown(
                        label: 'State',
                        value: selectedState,
                        items: snapshot?.data?.keys?.toList(),
                        onChanged: (value) {
                          selectedState = value;
                          selectedArea = null;
                          handleSetState();
                        }),
              ),
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
                label: 'Latitude',
                controller: latitudeController,
                textInputType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              controllers.utils.inputTextField(
                label: 'Longitude',
                controller: longitudeController,
                textInputType: TextInputType.numberWithOptions(
                    signed: true, decimal: true),
              ),
              controllers.utils.inputTextField(
                label: 'Contact number',
                controller: phoneController,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  controllers.utils.raisedButton('Cancel', () => Get.back()),
                  controllers.utils.raisedButton(
                    docSnap == null ? 'Confirm' : 'Update',
                    () async {
                      if (titleController.text.length > 0 &&
                          addressController.text.length > 0 &&
                          latitudeController.text.length > 0 &&
                          longitudeController.text.length > 0 &&
                          selectedArea != null &&
                          selectedState != null &&
                          phoneController.text.trim().length == 10) {
                        if (docSnap == null) {
                          controllers.showrooms.document().setData({
                            'name': titleController.text.trim().toLowerCase(),
                            'address':
                                addressController.text.trim().toLowerCase(),
                            'state': selectedState.trim().toLowerCase(),
                            'area': selectedArea.trim().toLowerCase(),
                            'latitude':
                                latitudeController.text.trim().toLowerCase(),
                            'longitude':
                                longitudeController.text.trim().toLowerCase(),
                            'timestamp': DateTime.now().millisecondsSinceEpoch,
                            'active': true,
                            'contactNumber': phoneController.text.trim()
                          });
                        } else {
                          controllers.showrooms
                              .document(docSnap.documentID)
                              .updateData({
                            'name': titleController.text.trim().toLowerCase(),
                            'address':
                                addressController.text.trim().toLowerCase(),
                            'state': selectedState.trim().toLowerCase(),
                            'area': selectedArea.trim().toLowerCase(),
                            'latitude':
                                latitudeController.text.trim().toLowerCase(),
                            'longitude':
                                longitudeController.text.trim().toLowerCase(),
                          });
                        }
                        Get.back();
                      } else {
                        controllers.utils.snackbar('Invalid Entries');
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  handleSetState() => (mounted) ? setState(() {}) : null;
}
