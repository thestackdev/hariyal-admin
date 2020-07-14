import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superuser/services/upload_product.dart';
import 'package:superuser/widgets/network_image.dart';

class EditDataScreen extends StatefulWidget {
  final DocumentSnapshot productSnap;
  final uid;

  EditDataScreen({this.uid, this.productSnap});

  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  List<Asset> newImages = [];
  List<dynamic> existingImages = [];
  String selectedCategory,
      selectedState,
      selectedShowroom,
      currentShowroom,
      currentShowroomAddress,
      selectedArea,
      addressID;
  List categoryList = [], areasList = [], statesList = [], showroomList = [];
  bool loading, _isOpen = false;
  GlobalKey rootKey = new GlobalKey();

  String uid;

  final price = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final showroomAddressController = TextEditingController();

  @override
  void initState() {
    Firestore.instance.collection('extras').getDocuments().then(
      (value) {
        value.documents.forEach((element) {
          if (element.documentID == 'category') {
            setState(() {
              element.data['category_array'].forEach((result) {
                categoryList.add(result);
              });
            });
          } else if (element.documentID == 'areas') {
            setState(() {
              element.data['areas_array'].forEach((result) {
                areasList.add(result);
              });
            });
          } else if (element.documentID == 'states') {
            setState(() {
              element.data['states_array'].forEach((result) {
                statesList.add(result);
              });
            });
          }
        });
      },
    );
    Firestore.instance.collection('showrooms').getDocuments().then((value) {
      setState(() {
        value.documents.forEach((element) {
          showroomList.add(element);
        });
      });
    });

    existingImages = widget.productSnap.data['images'];

    selectedCategory = widget.productSnap.data['category'];
    selectedState = widget.productSnap.data['location']['state'];
    selectedArea = widget.productSnap.data['location']['area'];

    addressID = widget.productSnap.data['adress'];

    Firestore.instance
        .collection('showrooms')
        .document(addressID)
        .get()
        .then((value) {
      currentShowroom = value.data['name'];
      currentShowroomAddress = value.data['adress'];
    });

    super.initState();
  }

  void showLoadingDialog(BuildContext context, String text) {
    setState(() {
      _isOpen = true;
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SimpleDialog(
              elevation: 9,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircularProgressIndicator(),
                      SizedBox(width: 18),
                      Expanded(
                        child: Text(
                          text,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  void hideDialog() {
    if (_isOpen) {
      Navigator.of(context).pop(true);
      _isOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rootKey,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              SizedBox(),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Existing images',
                  textScaleFactor: 1.5,
                ),
              ),
              SizedBox(),
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
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            color: Colors.grey.shade300),
                        margin: EdgeInsets.all(8),
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
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              color: Colors.red[800]),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              size: 21,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              if (mounted) {
                                setState(() {
                                  existingImages.removeAt(index);
                                });
                                Firestore.instance
                                    .collection('products')
                                    .document(widget.productSnap.documentID)
                                    .updateData({'images': existingImages});
                                FirebaseStorage.instance
                                    .ref()
                                    .getStorage()
                                    .getReferenceFromUrl(existingImages[index])
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
              SizedBox(),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Add new images',
                  textScaleFactor: 1.5,
                ),
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
                        color: Colors.grey.shade300,
                      ),
                      child: IconButton(
                        onPressed: () async {
                          if (await Permission.camera.request().isGranted &&
                              await Permission.storage.request().isGranted) {
                            try {
                              newImages = await MultiImagePicker.pickImages(
                                maxImages: 5,
                                enableCamera: true,
                                selectedAssets: newImages,
                                cupertinoOptions: CupertinoOptions(
                                  takePhotoIcon: "Pick Images",
                                ),
                                materialOptions: MaterialOptions(
                                  startInAllView: true,
                                  actionBarColor: "#abcdef",
                                  actionBarTitle: "Pick Images",
                                  allViewTitle: "Pick Images",
                                  useDetailsView: false,
                                  selectCircleStrokeColor: "#000000",
                                ),
                              );
                            } on Exception catch (e) {
                              Fluttertoast.showToast(msg: e.toString());
                            }

                            if (!mounted) return;

                            this.setState(() {});
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Insufficient Permissions');
                          }
                        },
                        icon: Icon(MdiIcons.plusOutline,
                            color: Colors.red.shade300),
                      ),
                    );
                  }
                  return Container(
                    margin: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.grey.shade300,
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
              DropdownButtonFormField(
                  value: selectedCategory,
                  decoration: getDecoration('Category'),
                  isExpanded: true,
                  iconEnabledColor: Colors.grey,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  iconSize: 30,
                  elevation: 0,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  },
                  items: categoryList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e.toString(),
                          style: TextStyle(color: Colors.black),
                        ));
                  }).toList()),
              SizedBox(
                height: 18,
              ),
              DropdownButtonFormField(
                  value: selectedState,
                  decoration: getDecoration('State'),
                  isExpanded: true,
                  iconEnabledColor: Colors.grey,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  iconSize: 30,
                  elevation: 0,
                  onChanged: (newValue) {
                    setState(() {
                      selectedState = newValue;
                    });
                  },
                  items: statesList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e.toString(),
                          style: TextStyle(color: Colors.black),
                        ));
                  }).toList()),
              SizedBox(
                height: 18,
              ),
              DropdownButtonFormField(
                  value: selectedArea,
                  decoration: getDecoration('Area'),
                  isExpanded: true,
                  iconEnabledColor: Colors.grey,
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                  iconSize: 30,
                  elevation: 0,
                  onChanged: (newValue) {
                    setState(() {
                      selectedArea = newValue;
                    });
                  },
                  items: areasList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e.toString(),
                          style: TextStyle(color: Colors.black),
                        ));
                  }).toList()),
              SizedBox(
                height: 18,
              ),
              DropdownButtonFormField(
                decoration: getDecoration('Showroom'),
                isExpanded: true,
                value: currentShowroom,
                iconEnabledColor: Colors.grey,
                style: TextStyle(color: Colors.grey, fontSize: 16),
                iconSize: 30,
                elevation: 9,
                onChanged: (newValue) {
                  setState(() {
                    selectedShowroom = newValue;
                    showroomList.forEach((element) {
                      if (element['name'] == newValue) {
                        setState(() {
                          showroomAddressController.text = element['adress'];
                          addressID = element.documentID;
                        });
                        return false;
                      } else {
                        return true;
                      }
                    });
                  });
                },
                items: showroomList.map(
                  (value) {
                    return DropdownMenuItem(
                      value: value['name'],
                      child: Text(value['name'],
                          style: TextStyle(color: Colors.black)),
                    );
                  },
                ).toList(),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                readOnly: true,
                maxLines: null,
                controller: showroomAddressController
                  ..text = currentShowroomAddress,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: getDecoration('Showroom Adress'),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                controller: price..text = widget.productSnap.data['price'],
                maxLines: null,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: getDecoration('Price'),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                controller: title..text = widget.productSnap.data['title'],
                maxLines: null,
                keyboardType: TextInputType.text,
                decoration: getDecoration('Title'),
              ),
              SizedBox(
                height: 18,
              ),
              TextField(
                controller: description
                  ..text = widget.productSnap.data['description'],
                maxLines: null,
                keyboardType: TextInputType.text,
                decoration: getDecoration('Description'),
              ),
              SizedBox(
                height: 18,
              ),
              Center(
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  elevation: 7,
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    showLoadingDialog(context, 'Loading Please wait...');
                    if (selectedCategory != null &&
                        selectedArea != null &&
                        selectedState != null &&
                        title.text.isNotEmpty != null &&
                        price.text.isNotEmpty &&
                        description.text.isNotEmpty != null) {
                      if (existingImages == null && newImages == null ||
                          existingImages.length <= 0 && newImages.length <= 0) {
                        Fluttertoast.showToast(msg: 'Invalid Selections');
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
                          adressID: addressID);
                      setState(() {
                        newImages.clear();
                        price.clear();
                        title.clear();
                        description.clear();
                      });
                      hideDialog();
                      Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                      Fluttertoast.showToast(msg: 'Invalid Selections');
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  color: Colors.red.shade300,
                  child: Text(
                    'Update Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  getDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      labelStyle: TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.0,
      ),
      fillColor: Colors.grey.shade200,
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.blue)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          borderSide: BorderSide(color: Colors.blue)),
    );
  }
}
