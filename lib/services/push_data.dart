import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:superuser/full_screen.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/upload_product.dart';

class PushData extends StatefulWidget {
  @override
  _PushDataState createState() => _PushDataState();
}

class _PushDataState extends State<PushData> {
  final controllers = Controllers.to;
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
  Map categoryMap = {};
  Map locationsMap = {};
  Map specificationsMap = {};
  Map inputSpecifications = {};

  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final price = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final showroomAddressController = TextEditingController();

  @override
  void initState() {
    categoryMap = controllers.categories.value.data;
    locationsMap = controllers.locations.value.data;
    specificationsMap = controllers.specifications.value.data;
    super.initState();
  }

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
    if (selectedCategory != null) {
      subCategory = categoryMap[selectedCategory];
    }
    if (selectedState != null) {
      areasList = locationsMap[selectedState];
    }

    return Scaffold(
      appBar: controllers.utils.appbar('Add Product'),
      body: controllers.utils.container(
        child: loading
            ? controllers.utils.progressIndicator()
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
                                    await controllers.utils.getSimpleDialouge(
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
                                            lockAspectRatio: false,
                                          ),
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
                                    OMIcons.plusOne,
                                    color: Colors.red.shade300,
                                  ),
                                ),
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.all(9),
                        child: GestureDetector(
                          onTap: () async {
                            Map<String, dynamic> map =
                                await Navigator.of(context).push(
                                    PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder:
                                            (BuildContext context, _, __) =>
                                                FullScreen(
                                                  index: index,
                                                  image: images[index],
                                                  imageLink: null,
                                                )));
                            if (map == null) return;
                            if (map['isDeleted'] == null ||
                                map['index'] == null ||
                                map['image'] == null) return;

                            if (map['isDeleted']) {
                              images.remove(map['image']);
                            } else {
                              images[map['index']] = map['image'];
                            }
                            handleSetState();
                          },
                          child: Hero(
                            tag: images[index].path.toString(),
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
                        controllers.utils.productInputDropDown(
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
                              controllers.utils
                                  .showSnackbar('Please select category first');
                            } else if (subCategory.length == 0) {
                              controllers.utils.showSnackbar(
                                  'No subcategories in $selectedCategory');
                            }
                          },
                          child: controllers.utils.productInputDropDown(
                              label: 'Sub-Category',
                              value: selectedSubCategory,
                              items: subCategory,
                              onChanged: (value) {
                                selectedSubCategory = value;
                                handleSetState();
                              }),
                        ),
                        controllers.utils.productInputDropDown(
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
                              controllers.utils
                                  .showSnackbar('Please select state first');
                            } else if (subCategory.length == 0) {
                              controllers.utils
                                  .showSnackbar('No areas in $selectedState');
                            }
                          },
                          child: controllers.utils.productInputDropDown(
                              label: 'Area',
                              value: selectedArea,
                              items: areasList,
                              onChanged: (newValue) async {
                                selectedArea = newValue;
                                selectedShowroom = null;
                                showroomAddressController.clear();
                                showroomList.clear();
                                controllers.utils.showSnackbar(
                                    'Loading showrooms in $selectedArea...');

                                await controllers.showrooms
                                    .where('active', isEqualTo: true)
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
                              controllers.utils
                                  .showSnackbar('Please select area first');
                            } else if (showroomList.length == 0) {
                              controllers.utils.showSnackbar(
                                  'No showrooms in $selectedArea');
                            }
                          },
                          child: controllers.utils.productInputDropDown(
                              label: 'Showroom',
                              items: showroomList,
                              value: selectedShowroom,
                              isShowroom: true,
                              onChanged: (newValue) {
                                selectedShowroom = newValue;
                                showroomList.forEach((element) {
                                  if (element['name'] == newValue) {
                                    showroomAddressController.text =
                                        element['address'];
                                    addressID = element.documentID;
                                    return false;
                                  } else {
                                    return true;
                                  }
                                });
                                handleSetState();
                              }),
                        ),
                        controllers.utils.inputTextField(
                          label: 'Showroom Address',
                          controller: showroomAddressController,
                          readOnly: true,
                        ),
                        controllers.utils.inputTextField(
                          label: 'Price',
                          controller: price,
                          inputFormatters: <TextInputFormatter>[
                            WhitelistingTextInputFormatter.digitsOnly,
                            ThousandsFormatter(),
                          ],
                          textInputType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: true,
                          ),
                        ),
                        controllers.utils.inputTextField(
                          label: 'Title',
                          controller: title,
                        ),
                        controllers.utils.inputTextField(
                          label: 'Description',
                          controller: description,
                        ),
                        if (specificationsList.length > 0) ...[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Add Specifications',
                              style: controllers.utils.textStyle(
                                color: Colors.red,
                                fontSize: 19,
                              ),
                            ),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: specificationsList.length,
                            itemBuilder: (context, index) {
                              return controllers.utils.inputTextField(
                                label: specificationsList[index],
                                onChanged: (value) {
                                  inputSpecifications[
                                      specificationsList[index]] = value;
                                },
                              );
                            },
                          ),
                        ]
                      ],
                    ),
                  ),
                  SizedBox(height: 18),
                  controllers.utils.getRaisedButton(
                    title: 'Add Product',
                    onPressed: onPressed,
                  ),
                  SizedBox(height: 30),
                ],
              ),
      ),
    );
  }

  onPressed() async {
    FocusScope.of(context).unfocus();
    if (globalKey.currentState.validate() && images.length > 0) {
      loading = true;
      handleSetState();
      await PushProduct().uploadProduct(
        images: images,
        category: selectedCategory,
        subCategory: selectedSubCategory,
        state: selectedState,
        area: selectedArea,
        adressID: addressID,
        price: double.parse(price.text.replaceAll(',', '')),
        title: title.text.toLowerCase(),
        description: description.text,
        specifications: inputSpecifications,
        uid: controllers.firebaseUser.value.uid,
        authored: controllers.isSuperuser.value,
      );
      clearAllData();
      loading = false;
      handleSetState();
      controllers.utils.showSnackbar('Item Added Sucessfully');
    } else {
      if (images.length == 0) {
        controllers.utils.showSnackbar('Please select atleast 1 image');
      }
    }
  }

  clearAllData() {
    selectedCategory = null;
    selectedSubCategory = null;
    selectedState = null;
    selectedArea = null;
    selectedShowroom = null;
    showroomAddressController.clear();
    images.clear();
    price.clear();
    title.clear();
    description.clear();
    specificationsList.clear();
    inputSpecifications.clear();
  }

  handleSetState() => (mounted) ? setState(() => null) : null;
}
