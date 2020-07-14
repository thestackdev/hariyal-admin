import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:superuser/services/upload_product.dart';

class PushData extends StatefulWidget {
  final uid;

  const PushData({Key key, this.uid}) : super(key: key);
  @override
  _PushDataState createState() => _PushDataState();
}

class _PushDataState extends State<PushData> {
  List<Asset> images = [];
  String selectedCategory;
  String selectedShowroom;
  String selectedState;
  String selectedArea;
  List categoryList = [];
  List areasList = [];
  List statesList = [];
  List showroomList = [];
  String addressID;
  bool loading;

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
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
                  color: Colors.grey.shade300,
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
                      Fluttertoast.showToast(msg: 'Insufficient Permissions');
                    }
                  },
                  icon: Icon(MdiIcons.plusOutline, color: Colors.red.shade300),
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
                asset: images[index],
                quality: 75,
                width: 270,
                height: 270,
              ),
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: DropdownButtonFormField(
              decoration: getDecoration('Category'),
              isExpanded: true,
              iconEnabledColor: Colors.grey,
              style: TextStyle(color: Colors.grey, fontSize: 16),
              iconSize: 30,
              elevation: 9,
              onChanged: (newValue) {
                setState(
                  () {
                    selectedCategory = newValue;
                  },
                );
              },
              items: categoryList.map<DropdownMenuItem<String>>(
                (e) {
                  return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e.toString(),
                    ),
                  );
                },
              ).toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: DropdownButtonFormField<String>(
              decoration: getDecoration('State'),
              isExpanded: true,
              iconEnabledColor: Colors.grey,
              style: TextStyle(color: Colors.grey, fontSize: 16),
              iconSize: 30,
              elevation: 9,
              onChanged: (newValue) {
                setState(() {
                  selectedState = newValue;
                });
              },
              items: statesList.map<DropdownMenuItem<String>>((e) {
                return DropdownMenuItem<String>(
                    value: e,
                    child: Text(
                      e,
                    ));
              }).toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: DropdownButtonFormField(
              decoration: getDecoration('Area'),
              isExpanded: true,
              iconEnabledColor: Colors.grey,
              style: TextStyle(color: Colors.grey, fontSize: 16),
              iconSize: 30,
              elevation: 9,
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
                    ));
              }).toList()),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: DropdownButtonFormField(
            decoration: getDecoration('Showroom'),
            isExpanded: true,
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
                  child: Text(
                    value['name'],
                  ),
                );
              },
            ).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: TextField(
            readOnly: true,
            maxLines: null,
            controller: showroomAddressController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: getDecoration('Showroom Adress'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: TextField(
            controller: price,
            maxLines: null,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: getDecoration('Price'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: TextField(
            controller: title,
            maxLines: null,
            keyboardType: TextInputType.text,
            decoration: getDecoration('Title'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 9),
          child: TextField(
            controller: description,
            maxLines: null,
            keyboardType: TextInputType.text,
            decoration: getDecoration('Description'),
          ),
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
              showDialog(
                context: context,
                barrierDismissible: false,
                child: SimpleDialog(
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
                              'Please wait until process is done , make user you dont exit the application',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              if (images.length > 0 &&
                  selectedCategory != null &&
                  selectedArea != null &&
                  selectedState != null &&
                  title != null &&
                  description != null) {
                await PushProduct().uploadProduct(
                  images,
                  selectedCategory,
                  selectedState,
                  selectedArea,
                  price.text,
                  title.text,
                  description.text,
                  widget.uid,
                  addressID,
                );
                setState(() {
                  images.clear();
                  price.clear();
                  title.clear();
                  description.clear();
                });
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
              'Push Data',
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
    );
  }

  getDecoration(String label) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      labelStyle: TextStyle(
        color: Colors.red.shade300,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.0,
      ),
      contentPadding: EdgeInsets.all(18),
      border: InputBorder.none,
      fillColor: Colors.grey.shade200,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
