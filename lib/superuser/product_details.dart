import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superuser/superuser/admin_screens/edit_data_screen.dart';
import 'package:superuser/widgets/image_slider.dart';

class ProductDetails extends StatefulWidget {
  final DocumentSnapshot productSnap;
  final uid;

  ProductDetails(this.productSnap, this.uid);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool loading = false;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Firestore firestore = Firestore.instance;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  ListView(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: ImageSliderWidget(
                          fit: BoxFit.contain,
                          imageHeight: MediaQuery.of(context).size.height / 2,
                          imageUrls: widget.productSnap.data['images'],
                          tag: widget.productSnap.documentID,
                          dotPosition: 20,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                        child: Text(
                          widget.productSnap.data['title'],
                          style: TextStyle(
                              fontSize: 26.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 20.0,
                              ),
                              Text(
                                widget.productSnap.documentID,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                            ],
                          )),
                          Text('${widget.productSnap.data['price']} Rs',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 26.0,
                              )),
                          SizedBox(
                            width: 20.0,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text("Description",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w400))),
                      Container(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 10.0),
                        child: Text(
                          widget.productSnap.data['description'],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      AppBar(
                        iconTheme: IconThemeData(color: Colors.black),
                        brightness: Brightness.light,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              color: Colors.deepOrange,
                              elevation: 0,
                              onPressed: () async {
                                try {
                                  setState(() {
                                    loading = true;
                                  });
                                  widget.productSnap.data['images']
                                      .forEach((element) async {
                                    StorageReference ref = await firebaseStorage
                                        .getReferenceFromUrl(
                                            widget.productSnap.data[element]);
                                    ref.delete();
                                  });
                                  firestore
                                      .collection('products')
                                      .document(widget.productSnap.documentID)
                                      .delete();
                                  firestore
                                      .collection('admin')
                                      .document(widget.uid)
                                      .collection('products')
                                      .document(widget.productSnap.documentID)
                                      .delete();
                                  Navigator.of(context).pop();
                                } catch (e) {
                                  Fluttertoast.showToast(msg: e.toString());
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "Delete",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: MaterialButton(
                              color: Colors.black54,
                              elevation: 0,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditDataScreen(
                                      uid: widget.uid,
                                      productSnap: widget.productSnap,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(15.0),
                                child: Text(
                                  "Edit",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
      ),
    );
  }
}
