import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/upload_product.dart';
import 'package:superuser/utils.dart';

class PushData extends StatefulWidget {
  @override
  _PushDataState createState() => _PushDataState();
}

class _PushDataState extends State<PushData> {
  List<Asset> images = [];
  String selectedCategory;
  String selectedShowroom;
  String selectedState;
  String selectedArea;
  String selectedSubCategory;
  List subCategory = [];
  List areasList = [];
  List showroomList = [];
  String addressID;
  bool loading = false;
  Utils utils;
  Map categoryMap = {};
  Map locationsMap = {};
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  final price = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final showroomAddressController = TextEditingController();
  final specificationController = TextEditingController();
  Firestore firestore = Firestore.instance;

  initData() async {
    loading = true;
    handleSetState();

    await firestore.collection('showrooms').getDocuments().then((value) {
      showroomList.addAll(value.documents);
    });
    loading = false;
    handleSetState();
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  void dispose() {
    price.dispose();
    title.dispose();
    description.dispose();
    showroomAddressController.dispose();
    specificationController.dispose();
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
                        child: IconButton(
                          onPressed: () async {
                            if (await Permission.camera.request().isGranted &&
                                await Permission.storage.request().isGranted) {
                              try {
                                images = await MultiImagePicker.pickImages(
                                  maxImages: 5,
                                  enableCamera: true,
                                  selectedAssets: images,
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
                              utils.showSnackbar('Insufficient Permissions');
                            }
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
                      child: AssetThumb(
                        spinner: utils.progressIndicator(),
                        asset: images[index],
                        quality: 50,
                        width: 270,
                        height: 270,
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
                            handleSetState();
                          }),
                      utils.productInputDropDown(
                          label: 'Sub-Category',
                          value: selectedSubCategory,
                          items: subCategory,
                          onChanged: (value) {
                            selectedSubCategory = value;
                            handleSetState();
                          }),
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
                          items: areasList,
                          onChanged: (newValue) {
                            selectedArea = newValue;
                            handleSetState();
                          }),
                      utils.productInputDropDown(
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
                      utils.productInputText(
                        label: 'Specifications',
                        controller: specificationController,
                        textInputAction: TextInputAction.newline,
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
        specificationController.text.length > 0) {
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
        specifications: specificationController.text,
        uid: Provider
            .of<DocumentSnapshot>(context, listen: false)
            .documentID,
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
    images.clear();
    price.clear();
    title.clear();
    description.clear();
    specificationController.clear();
  }

  handleSetState() => (mounted) ? setState(() {}) : null;
}
