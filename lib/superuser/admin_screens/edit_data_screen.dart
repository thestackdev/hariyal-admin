import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superuser/services/upload_product.dart';
import 'package:superuser/widgets/network_image.dart';

import '../../utils.dart';

class EditDataScreen extends StatefulWidget {
  final DocumentSnapshot productSnap;
  final uid;

  EditDataScreen({this.uid, this.productSnap});

  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Utils utils = Utils();
  List<Asset> newImages = [];
  List existingImages = [];
  String selectedCategory,
      selectedState,
      selectedShowroom,
      selectedArea,
      addressID;
  List categoryList = [], areasList = [], statesList = [];
  List<DocumentSnapshot> showroomList = [];

  String uid;

  final price = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final showroomAddressController = TextEditingController();
  Firestore firestore = Firestore.instance;
  bool loading = false;
  final textstyle = TextStyle(color: Colors.grey, fontSize: 16);

  fetchPreviousData() async {
    loading = true;
    handleSetState();
    existingImages = widget.productSnap.data['images'];
    selectedCategory = widget.productSnap.data['category'];
    selectedState = widget.productSnap.data['location']['state'];
    selectedArea = widget.productSnap.data['location']['area'];
    addressID = widget.productSnap.data['adress'];
    price.text = widget.productSnap.data['price'];
    title.text = widget.productSnap.data['title'];

    description.text = widget.productSnap.data['description'];

    await firestore.collection('extras').getDocuments().then((value) {
      value.documents.forEach((element) {
        if (element.documentID == 'category') {
          categoryList.addAll(element.data['category_array']);
        } else if (element.documentID == 'areas') {
          areasList.addAll(element.data['areas_array']);
        } else if (element.documentID == 'states') {
          statesList.addAll(element.data['states_array']);
        }
      });
    });
    await firestore.collection('showrooms').getDocuments().then((value) {
      showroomList.addAll(value.documents);
      value.documents.forEach((element) {
        if (element.documentID == widget.productSnap.data['adress']) {
          selectedShowroom = element['name'];
          showroomAddressController.text = element['adress'];
        }
      });
    });

    loading = false;
    handleSetState();
  }

  @override
  void initState() {
    fetchPreviousData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: utils.getAppbar('Edit Product'),
      body: utils.getContainer(
        child: loading
            ? utils.getLoadingIndicator()
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
                      Container(
                        alignment: FractionalOffset.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade100,
                        ),
                        margin: EdgeInsets.all(5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: PNetworkImage(
                            existingImages[index],
                            fit: BoxFit.contain,
                          ),
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
                              if (mounted) {
                                setState(() {
                                  existingImages.removeAt(index);
                                });
                                Firestore.instance
                                    .collection('products')
                                    .document(
                                    widget.productSnap.documentID)
                                    .updateData(
                                    {'images': existingImages});
                                FirebaseStorage.instance
                                    .ref()
                                    .getStorage()
                                    .getReferenceFromUrl(
                                    existingImages[index])
                                    .then((value) {
                                  value.delete();
                                });
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
                              utils.getSnackbar(
                                  scaffoldKey, e.toString());
                            }
                          } else {
                            utils.getSnackbar(
                                scaffoldKey, 'Insufficient Permissions');
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                child: DropdownButtonFormField(
                    decoration: utils.getDecoration(label: 'Category'),
                    value: selectedCategory,
                    isExpanded: true,
                    iconEnabledColor: Colors.grey,
                    style: textstyle,
                    iconSize: 30,
                    elevation: 9,
                    onChanged: (newValue) {
                      selectedCategory = newValue;
                      handleSetState();
                    },
                    items: categoryList.map((e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      );
                    }).toList()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                child: DropdownButtonFormField(
                    decoration: utils.getDecoration(label: 'State'),
                    value: selectedState,
                    isExpanded: true,
                    iconEnabledColor: Colors.grey,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                    iconSize: 30,
                    elevation: 9,
                    onChanged: (newValue) {
                      selectedState = newValue;
                      handleSetState();
                    },
                    items: statesList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList()),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                child: DropdownButtonFormField(
                    decoration: utils.getDecoration(label: 'Area'),
                    value: selectedArea,
                    isExpanded: true,
                    iconEnabledColor: Colors.grey,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                    iconSize: 30,
                    elevation: 9,
                    onChanged: (newValue) {
                      selectedArea = newValue;
                      handleSetState();
                    },
                    items: areasList.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 9,
                ),
                child: DropdownButtonFormField(
                  decoration: utils.getDecoration(label: 'Showroom'),
                  value: selectedShowroom,
                  isExpanded: true,
                  iconEnabledColor: Colors.grey,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  iconSize: 30,
                  elevation: 9,
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
                  },
                  items: showroomList.map((value) {
                    return DropdownMenuItem(
                      value: value['name'],
                      child: Text(
                        value['name'],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                child: TextField(
                  style: textstyle,
                  readOnly: true,
                  maxLines: null,
                  controller: showroomAddressController,
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  decoration:
                  utils.getDecoration(label: 'Showroom Adress'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 9,
                ),
                child: TextField(
                  style: textstyle,
                  controller: price,
                  maxLines: null,
                  keyboardType:
                  TextInputType.numberWithOptions(decimal: true),
                  decoration: utils.getDecoration(label: 'Price'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                child: TextField(
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  controller: title,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: utils.getDecoration(label: 'Title'),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                child: TextField(
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  controller: description,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: utils.getDecoration(label: 'Description'),
                ),
              ),
              SizedBox(
                height: 18,
              ),
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
    FocusScope.of(context).unfocus();
    loading = true;
    handleSetState();
    if (selectedCategory != null &&
        selectedArea != null &&
        selectedState != null &&
        title.text.isNotEmpty != null &&
        price.text.isNotEmpty &&
        description.text.isNotEmpty != null) {
      if (existingImages == null && newImages == null ||
          existingImages.length <= 0 && newImages.length <= 0) {
        utils.getSnackbar(scaffoldKey, 'Invalid Selections');
        return;
      }

      await PushProduct().updateProduct(
        newImages: newImages,
        docID: widget.productSnap.documentID,
        oldImages: existingImages,
        category: selectedCategory,
        state: selectedState,
        area: selectedArea,
        price: price.text,
        title: title.text,
        description: description.text,
        uid: widget.uid,
        adressID: addressID,
      );

      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      utils.getSnackbar(scaffoldKey, 'Invalid Selections');
    }
  }

  handleSetState() {
    if (mounted) {
      setState(() {});
    }
  }
}
