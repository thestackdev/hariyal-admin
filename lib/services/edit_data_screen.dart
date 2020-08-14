import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:pattern_formatter/numeric_formatter.dart';
import 'package:superuser/full_screen.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/upload_product.dart';

class EditDataScreen extends StatefulWidget {
  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  final controllers = Controllers.to;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  final DocumentSnapshot docsnap = Get.arguments;

  Map categoryMap = {};
  Map locationsMap = {};
  Map specificationsMap = {};
  Map inputSpecifications = {};
  List subCategory = [];
  String selectedSubCategory;

  List<File> newImages = [];
  List existingImages = [];
  String selectedCategory;
  String selectedState;
  String selectedShowroom;
  String selectedArea;
  String addressID;
  List areasList = [];
  List<DocumentSnapshot> showroomList = [];
  List specificationsList = [];

  final price = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final showroomAddressController = TextEditingController();
  bool loading = false;
  final textstyle = TextStyle(color: Colors.grey, fontSize: 16);
  List shouldRemoveImages = [];

  fetchPreviousData() async {
    existingImages = docsnap.data['images'];
    selectedCategory = docsnap.data['category']['category'];
    selectedSubCategory = docsnap.data['category']['subCategory'];
    selectedState = docsnap.data['location']['state'];
    selectedArea = docsnap.data['location']['area'];
    addressID = docsnap.data['address'];
    price.text = docsnap.data['price'].toString();
    title.text = docsnap.data['title'];
    description.text = docsnap.data['description'];
    inputSpecifications = docsnap.data['specifications'];

    await controllers.showrooms
        .where('area', isEqualTo: selectedArea)
        .getDocuments()
        .then((value) {
      showroomList.addAll(value.documents);
      for (var doc in value.documents) {
        print(addressID);
        print(doc.documentID);
        if (doc.documentID == addressID) {
          selectedShowroom = doc.data['name'];

          showroomAddressController.text = doc.data['address'];
        }
      }

      if (specificationsMap[selectedCategory] != null) {
        specificationsList.addAll(specificationsMap[selectedCategory]);
      }

      handleSetState();
    });
  }

  @override
  void initState() {
    fetchPreviousData();
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
    return controllers.utils.root(
      label: 'Edit Product',
      child: loading
          ? controllers.utils.loading()
          : Padding(
              padding: EdgeInsets.all(9),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: List.generate(existingImages.length, (index) {
                      return GestureDetector(
                        onTap: () async {
                          Map<String, dynamic> map = await Navigator.of(context)
                              .push(PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) =>
                                      FullScreen(
                                        index: index,
                                        image: null,
                                        imageLink: existingImages[index],
                                      )));
                          if (map == null) return;
                          if (map['isDeleted'] == null ||
                              map['index'] == null ||
                              map['image'] == null) return;
                          if (map['isDeleted']) {
                            shouldRemoveImages.add(map['image']);
                            existingImages.remove(map['image']);
                          } else {
                            existingImages[map['index']] = map['image'];
                          }
                          handleSetState();
                        },
                        child: Hero(
                            tag: existingImages[index],
                            child: Padding(
                              padding: EdgeInsets.all(9),
                              child: CachedNetworkImage(
                                imageUrl: existingImages[index],
                                fit: BoxFit.contain,
                                width: 270,
                                height: 270,
                              ),
                            )),
                      );
                    }),
                  ),
                  GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    children: List.generate(newImages.length + 1, (index) {
                      if (index == newImages.length) {
                        return newImages.length >= 5
                            ? Container()
                            : IconButton(
                                onPressed: () async {
                                  dynamic source;

                                  await Get.bottomSheet(
                                    Container(
                                        height: 90,
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(
                                                  OMIcons.camera,
                                                  size: 36,
                                                  color: Colors.redAccent,
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                  return source =
                                                      ImageSource.camera;
                                                }),
                                            IconButton(
                                              icon: Icon(
                                                OMIcons.image,
                                                size: 36,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () {
                                                Get.back();
                                                return source =
                                                    ImageSource.gallery;
                                              },
                                            )
                                          ],
                                        )),
                                    backgroundColor: Colors.white,
                                  );

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

                                      newImages.add(croppedFile);
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
                                                  image: newImages[index],
                                                  imageLink: null,
                                                )));
                            if (map == null) return;
                            if (map['isDeleted'] == null ||
                                map['index'] == null ||
                                map['image'] == null) return;

                            if (map['isDeleted']) {
                              newImages.remove(map['image']);
                            } else {
                              newImages[map['index']] = map['image'];
                            }
                            handleSetState();
                          },
                          child: Hero(
                            tag: newImages[index].path.toString(),
                            child: Image.file(
                              newImages[index],
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
                  SizedBox(height: 18),
                  Form(
                    key: globalKey,
                    child: Wrap(
                      spacing: 18,
                      runSpacing: 18,
                      children: <Widget>[
                        controllers.utils.productInputDropDown(
                            label: 'Category',
                            value: selectedCategory,
                            items: categoryMap?.keys?.toList(),
                            onTap: () => print('called'),
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
                        controllers.utils.productInputDropDown(
                            label: 'Sub-Category',
                            value: selectedSubCategory,
                            items: subCategory,
                            onChanged: (value) {
                              selectedSubCategory = value;
                              handleSetState();
                            },
                            onTap: () {
                              if (selectedCategory == null) {
                                controllers.utils
                                    .snackbar('Please select category first');
                              } else if (subCategory.length == 0) {
                                controllers.utils.snackbar(
                                    'No subcategories in $selectedCategory');
                              }
                            }),
                        controllers.utils.productInputDropDown(
                            label: 'State',
                            value: selectedState,
                            items: locationsMap?.keys?.toList(),
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
                                  .snackbar('Please select state first');
                            } else if (subCategory.length == 0) {
                              controllers.utils
                                  .snackbar('No areas in $selectedState');
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
                                controllers.utils.snackbar(
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
                                  .snackbar('Please select area first');
                            } else if (showroomList.length == 0) {
                              controllers.utils
                                  .snackbar('No showrooms in $selectedArea');
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
                            child: Text('Add Specifications',
                                style: Get.textTheme.headline4),
                          ),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: specificationsList.length,
                            itemBuilder: (context, index) {
                              return controllers.utils.inputTextField(
                                label: specificationsList[index],
                                initialValue: inputSpecifications[
                                    specificationsList[index]],
                                onChanged: (value) {
                                  inputSpecifications[
                                      specificationsList[index]] = value;
                                },
                              );
                            },
                          ),
                        ],
                        controllers.utils
                            .raisedButton('Update Data', onPressed),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  onPressed() async {
    FocusScope.of(context).unfocus();
    if (globalKey.currentState.validate()) {
      if (newImages.length > 0 || existingImages.length > 0) {
        loading = true;
        handleSetState();

        shouldRemoveImages.forEach((element) {
          FirebaseStorage.instance
              .ref()
              .getStorage()
              .getReferenceFromUrl(element)
              .then((value) {
            value.delete();
          });
        });

        Firestore.instance
            .collection('products')
            .document(docsnap.documentID)
            .updateData({'images': existingImages});

        await PushProduct().updateProduct(
            newImages: newImages,
            category: selectedCategory,
            docID: docsnap.documentID,
            oldImages: existingImages,
            subCategory: selectedSubCategory,
            state: selectedState,
            area: selectedArea,
            adressID: addressID,
            price: double.parse(price.text.replaceAll(',', '')),
            title: title.text.trim().toLowerCase(),
            description: description.text.trim().toLowerCase(),
            specifications: inputSpecifications,
            searchList: controllers.utils
                .getProductSearchList(title.text.trim().toLowerCase()));

        loading = false;
        handleSetState();
        controllers.utils.snackbar('Item Updated Sucessfully');
      } else {
        controllers.utils.snackbar('Upload alteast 1 image');
      }
    }
  }

  handleSetState() => (mounted) ? setState(() => null) : null;
}
