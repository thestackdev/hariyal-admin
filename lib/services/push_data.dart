import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/full_screen.dart';
import 'package:superuser/services/upload_product.dart';
import 'package:superuser/utils.dart';

class PushData extends StatefulWidget {
  @override
  _PushDataState createState() => _PushDataState();
}

class _PushDataState extends State<PushData> {
  List<File> images = [];
  String selectedCategory;
  String selectedSubCategory;
  String selectedState;
  String selectedArea;
  String selectedShowroom;
  List subCategory = [];
  List areasList = [];
  List showroomList = [];
  List specificationsList = [];
  String addressID;
  bool loading = false;
  Utils utils;

  Map categoryMap = {};
  Map locationsMap = {};
  Map specificationsMap = {};
  Map inputSpecifications = {};

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final price = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final showroomAddressController = TextEditingController();
  Firestore firestore = Firestore.instance;

  @override
  void dispose() {
    price.dispose();
    title.dispose();
    description.dispose();
    showroomAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    utils = context.watch<Utils>();
    final QuerySnapshot extras = context.watch<QuerySnapshot>();

    if (extras != null) {
      for (var map in extras.documents) {
        if (map.documentID == 'category') {
          categoryMap.addAll(map.data);
        } else if (map.documentID == 'locations') {
          locationsMap.addAll(map.data);
        } else if (map.documentID == 'specifications') {
          specificationsMap.addAll(map.data);
        }
      }
      if (selectedCategory != null) {
        subCategory = categoryMap[selectedCategory];
      }
      if (selectedState != null) {
        areasList = locationsMap[selectedState];
      }
    }

    return utils.container(
      child: loading
          ? utils.progressIndicator()
          : ListView(
              children: <Widget>[
                SizedBox(height: 9),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  children: List.generate(images.length + 1, (index) {
                    if (index == images.length) {
                      return Container(
                        margin: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.grey.shade100,
                        ),
                        child: images.length >= 5
                            ? Container()
                            : IconButton(
                                onPressed: () async {
                                  dynamic source;
                                  await utils.getSimpleDialouge(
                                      title: 'Select an option',
                                      yesText: 'Select from gallery',
                                      noText: 'Take a picture',
                                      yesPressed: () {
                                        Navigator.of(context).pop();
                                        return source = ImageSource.gallery;
                                      },
                                      noPressed: () {
                                        Navigator.of(context).pop();
                                        return source = ImageSource.camera;
                                      });

                                  try {
                                    final pickedFile = await ImagePicker()
                                        .getImage(
                                            source: source, imageQuality: 75);
                                    if (pickedFile != null) {
                                      File croppedFile =
                                          await ImageCropper.cropImage(
                                        sourcePath: pickedFile.path,
                                        aspectRatioPresets: [
                                          CropAspectRatioPreset.square,
                                          CropAspectRatioPreset.ratio3x2,
                                          CropAspectRatioPreset.original,
                                          CropAspectRatioPreset.ratio4x3,
                                          CropAspectRatioPreset.ratio16x9
                                        ],
                                        androidUiSettings: AndroidUiSettings(
                                            toolbarTitle: 'Crop Image',
                                            toolbarColor:
                                                Theme.of(context).accentColor,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.original,
                                            lockAspectRatio: false),
                                      );
                                      if (croppedFile == null) {
                                        return;
                                      }

                                      images.add(croppedFile);
                                    }
                                  } catch (e) {
                                    print(e.toString());
                                  }

                                  handleSetState();
                                },
                                icon: Icon(
                                  MdiIcons.plusOutline,
                                  color: Colors.red.shade300,
                                ),
                              ),
                      );
                    }
                    return Padding(
                      padding: EdgeInsets.all(9),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  FullScreen(
                                    tag: index,
                                    image: images[index],
                                  )));
                        },
                        child: Hero(
                          tag: index,
                          child: Image.file(
                            images[index],
                            width: 270,
                            height: 270,
                            errorBuilder: (context, url, error) =>
                                Icon(Icons.error_outline),
                            filterQuality: FilterQuality.medium,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                Form(
                  key: globalKey,
                  child: Column(
                    children: <Widget>[
                      utils.productInputDropDown(
                          label: 'Category',
                          value: selectedCategory,
                          items: categoryMap.keys.toList(),
                          onChanged: (value) {
                            selectedCategory = value;
                            selectedSubCategory = null;
                            specificationsList.clear();
                            if (specificationsMap[value] != null) {
                              specificationsList
                                  .addAll(specificationsMap[value]);
                            }

                            handleSetState();
                          }),
                      GestureDetector(
                        onTap: () {
                          if (selectedCategory == null) {
                            utils.showSnackbar('Please select category first');
                          } else if (subCategory.length == 0) {
                            utils.showSnackbar(
                                'No subcategories in $selectedCategory');
                          }
                        },
                        child: utils.productInputDropDown(
                            label: 'Sub-Category',
                            value: selectedSubCategory,
                            items: subCategory,
                            onChanged: (value) {
                              selectedSubCategory = value;
                              handleSetState();
                            }),
                      ),
                      utils.productInputDropDown(
                          label: 'State',
                          value: selectedState,
                          items: locationsMap.keys.toList(),
                          onChanged: (value) {
                            selectedState = value;
                            selectedArea = null;
                            selectedShowroom = null;
                            showroomAddressController.clear();
                            showroomList.clear();
                            handleSetState();
                          }),
                      GestureDetector(
                        onTap: () {
                          if (selectedState == null) {
                            utils.showSnackbar('Please select state first');
                          } else if (subCategory.length == 0) {
                            utils.showSnackbar('No areas in $selectedState');
                          }
                        },
                        child: utils.productInputDropDown(
                            label: 'Area',
                            value: selectedArea,
                            items: areasList,
                            onChanged: (newValue) async {
                              selectedArea = newValue;
                              selectedShowroom = null;
                              showroomAddressController.clear();
                              showroomList.clear();
                              utils.showSnackbar(
                                  'Loading showrooms in $selectedArea...');

                              await firestore
                                  .collection('showrooms')
                                  .where('area', isEqualTo: newValue)
                                  .getDocuments()
                                  .then((value) {
                                showroomList.addAll(value.documents);
                                handleSetState();
                              });
                            }),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (selectedArea == null) {
                            utils.showSnackbar('Please select area first');
                          } else if (showroomList.length == 0) {
                            utils.showSnackbar('No showrooms in $selectedArea');
                          }
                        },
                        child: utils.productInputDropDown(
                            label: 'Showroom',
                            items: showroomList,
                            value: selectedShowroom,
                            isShowroom: true,
                            onChanged: (newValue) {
                              selectedShowroom = newValue;
                              showroomList.forEach((element) {
                                if (element['name'] == newValue) {
                                  showroomAddressController.text =
                                      element['adress'];
                                  addressID = element.documentID;
                                  return false;
                                } else {
                                  return true;
                                }
                              });
                              handleSetState();
                            }),
                      ),
                      utils.productInputText(
                        label: 'Showroom Address',
                        controller: showroomAddressController,
                        readOnly: true,
                      ),
                      utils.productInputText(
                        label: 'Price',
                        controller: price,
                        textInputType: TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                      utils.productInputText(
                        label: 'Title',
                        controller: title,
                      ),
                      utils.productInputText(
                        label: 'Description',
                        controller: description,
                      ),
                      if (specificationsList.length > 0)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Add Specifications',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: specificationsList.length,
                        itemBuilder: (context, index) {
                          return utils.textInputPadding(
                            child: TextField(
                              decoration: utils.inputDecoration(
                                label: specificationsList[index],
                              ),
                              onChanged: (value) {
                                inputSpecifications[specificationsList[index]] =
                                    value;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                utils.getRaisedButton(
                  title: 'Add Product',
                  onPressed: onPressed,
                ),
                SizedBox(height: 50),
              ],
            ),
    );
  }

  onPressed() async {
    if (globalKey.currentState.validate() &&
        images.length > 0 &&
        title != null &&
        price.text.length > 0 &&
        title.text.length > 0 &&
        description.text.length > 0 &&
        inputSpecifications.values.length > 0) {
      FocusScope.of(context).unfocus();
      loading = true;
      handleSetState();
      await PushProduct().uploadProduct(
        images: images,
        category: selectedCategory,
        subCategory: selectedSubCategory,
        state: selectedState,
        area: selectedArea,
        adressID: addressID,
        price: price.text,
        title: title.text.toLowerCase(),
        description: description.text,
        specifications: inputSpecifications,
        uid: Provider.of<DocumentSnapshot>(context, listen: false).documentID,
      );
      clearAllData();
      loading = false;
      handleSetState();
      utils.showSnackbar('Item Added Sucessfully');
    } else {
      utils.showSnackbar('Invalid Selections');
    }
  }

  clearAllData() {
    selectedCategory = null;
    selectedSubCategory = null;
    selectedState = null;
    selectedArea = null;
    selectedShowroom = null;
    showroomAddressController.clear();
    inputSpecifications.clear();
    images.clear();
    price.clear();
    title.clear();
    description.clear();
  }

  handleSetState() => (mounted) ? setState(() => null) : null;
}
