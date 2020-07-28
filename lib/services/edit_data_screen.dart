import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/upload_product.dart';
import 'package:superuser/widgets/network_image.dart';

import '../utils.dart';

class EditDataScreen extends StatefulWidget {
  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  final DocumentSnapshot docsnap = Get.arguments;

/////////////////
  Map categoryMap = {};
  Map locationsMap = {};
  Map specificationsMap = {};
  Map inputSpecifications = {};
  List subCategory = [];
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String selectedSubCategory;

////////////////////

  Utils utils;
  List<Asset> newImages = [];
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
  Firestore firestore = Firestore.instance;
  bool loading = false;
  final textstyle = TextStyle(color: Colors.grey, fontSize: 16);
  List shouldRemoveImages = [];

  fetchPreviousData() async {
    existingImages = docsnap.data['images'];
    selectedCategory = docsnap.data['category']['category'];
    selectedSubCategory = docsnap.data['category']['subCategory'];
    selectedState = docsnap.data['location']['state'];
    selectedArea = docsnap.data['location']['area'];
    addressID = docsnap.data['adress'];
    price.text = docsnap.data['price'];
    title.text = docsnap.data['title'];
    description.text = docsnap.data['description'];
    inputSpecifications = docsnap.data['specifications'];

    await firestore
        .collection('showrooms')
        .where('area', isEqualTo: selectedArea)
        .getDocuments()
        .then((value) {
      showroomList.addAll(value.documents);
      for (var doc in value.documents) {
        if (doc.documentID == addressID) {
          selectedShowroom = doc.data['name'];
          showroomAddressController.text = doc.data['adress'];
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
    utils = context.watch<Utils>();
    final QuerySnapshot extras = context.watch<QuerySnapshot>();

    if (extras == null) {
      return utils.blankScreenLoading();
    }

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
    return Scaffold(
      appBar: utils.appbar('Edit Product'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
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
                        return Stack(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(9),
                              child: PNetworkImage(
                                existingImages[index],
                                fit: BoxFit.contain,
                                width: 270,
                                height: 270,
                              ),
                            ),
                            Align(
                              child: Container(
                                height: 30,
                                width: 30,
                                margin: EdgeInsets.all(9),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                  color: Colors.red[800],
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    try {
                                      shouldRemoveImages
                                          .add(existingImages[index]);
                                      existingImages
                                          .remove(existingImages[index]);

                                      handleSetState();
                                    } catch (e) {
                                      utils.showSnackbar(e.toString());
                                    }
                                  },
                                ),
                              ),
                              alignment: Alignment.topRight,
                            )
                          ],
                        );
                      }),
                    ),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      children: List.generate(newImages.length + 1, (index) {
                        if (index == newImages.length) {
                          return Container(
                            margin: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey.shade100,
                            ),
                            child: IconButton(
                              onPressed: () async {
                                if (await Permission.camera
                                        .request()
                                        .isGranted &&
                                    await Permission.storage
                                        .request()
                                        .isGranted) {
                                  try {
                                    newImages =
                                        await MultiImagePicker.pickImages(
                                      maxImages: 5,
                                      enableCamera: true,
                                      selectedAssets: newImages,
                                      materialOptions: MaterialOptions(
                                        statusBarColor: '#FF6347',
                                        startInAllView: true,
                                        actionBarColor: "#FF6347",
                                        actionBarTitle: "Pick Images",
                                        allViewTitle: "Pick Images",
                                        useDetailsView: false,
                                        selectCircleStrokeColor: "#FF6347",
                                      ),
                                    );
                                    handleSetState();
                                  } catch (e) {
                                    utils.showSnackbar(e.toString());
                                  }
                                } else {
                                  utils
                                      .showSnackbar('Insufficient Permissions');
                                }
                              },
                              icon: Icon(
                                MdiIcons.plusOutline,
                                color: Colors.red.shade300,
                              ),
                            ),
                          );
                        }
                        return Container(
                          margin: EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                            color: Colors.grey.shade100,
                          ),
                          child: AssetThumb(
                            asset: newImages[index],
                            quality: 50,
                            width: 270,
                            height: 270,
                          ),
                        );
                      }),
                    ),
                    SizedBox(
                      height: 18,
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
                                utils.showSnackbar(
                                    'Please select category first');
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
                                utils
                                    .showSnackbar('No areas in $selectedState');
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
                                utils.showSnackbar(
                                    'No showrooms in $selectedArea');
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
                            textInputType:
                                TextInputType.numberWithOptions(signed: true),
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
                                child: TextFormField(
                                  initialValue: inputSpecifications[
                                      specificationsList[index]],
                                  decoration: utils.inputDecoration(
                                    label: specificationsList[index],
                                  ),
                                  onChanged: (value) {
                                    inputSpecifications[
                                        specificationsList[index]] = value;
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
                        title: 'Update Data', onPressed: onPressed),
                    SizedBox(height: 50),
                  ],
                ),
              ),
      ),
    );
  }

  onPressed() async {
    if (globalKey.currentState.validate() &&
        title != null &&
        price.text.length > 0 &&
        title.text.length > 0 &&
        description.text.length > 0) {
      if (existingImages.length == 0 && newImages.length > 0 ||
          existingImages.length > 0 && newImages.length == 0) {
        FocusScope.of(context).unfocus();
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
          price: price.text,
          title: title.text.toLowerCase(),
          description: description.text,
          specifications: inputSpecifications,
        );

        loading = false;
        handleSetState();
        utils.showSnackbar('Item Updated Sucessfully');
      } else {
        utils.showSnackbar('Upload alteast one image');
      }
    } else {
      utils.showSnackbar('Invalid Selections');
    }
  }

  handleSetState() => (mounted) ? setState(() => null) : null;
}
