import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:strings/strings.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/image_slider.dart';
import 'package:superuser/widgets/image_view.dart';

//import '../services/edit_data_screen.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Utils utils = Utils();
  bool loading = false;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Firestore firestore = Firestore.instance;
  final textController = TextEditingController();
  final docId = Get.arguments;

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Product Details'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
            : DataStreamBuilder<DocumentSnapshot>(
                errorBuilder: (context, error) => utils.nullWidget(error),
                loadingBuilder: (context) => utils.progressIndicator(),
                stream: firestore
                    .collection('products')
                    .document(docId)
                    .snapshots(),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      ListView(
                        padding: EdgeInsets.all(9),
                        children: <Widget>[
                          ImageSliderWidget(
                            onTap: () => Get.to(
                              HariyalImageView(
                                imageUrls: snapshot.data['images'],
                              ),
                            ),
                            fit: BoxFit.contain,
                            imageHeight: MediaQuery.of(context).size.height / 2,
                            imageUrls: snapshot.data['images'],
                            tag: snapshot.documentID,
                            dotPosition: 20,
                          ),
                          SizedBox(height: 10),
                          Text(
                            capitalize('${snapshot.data['title']}'),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 9),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SelectableText(
                                snapshot.documentID,
                                style: utils.textStyle(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              Text(
                                '${snapshot.data['price']} Rs',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 26.0),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            capitalize('${snapshot.data['description']}'),
                            textAlign: TextAlign.justify,
                            style: utils.inputTextStyle(),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Specifications',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: 9),
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                snapshot.data['specifications'].keys.length,
                            itemBuilder: (context, index) {
                              final keys =
                                  snapshot.data['specifications'].keys.toList();
                              return Row(
                                children: <Widget>[
                                  Text(
                                    '${keys[index]}  :  ',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data['specifications']
                                        [keys[index]],
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 20,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 9),
                          !snapshot.data['isSold']
                              ? Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: utils.productInputText(
                                        label: 'Sold Reason',
                                        controller: textController,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: utils.getRaisedButton(
                                          title: 'SOLD',
                                          onPressed: () {
                                            if (textController.text.length >
                                                0) {
                                              snapshot.reference.updateData({
                                                'isSold': true,
                                                'soldReason':
                                                textController.text
                                              });
                                              textController.clear();
                                            } else {
                                              utils.showSnackbar(
                                                  'Reason can\'t be empty');
                                            }
                                          }),
                                    )
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        'Sold Reason : ${snapshot.data['soldReason']}',
                                        textAlign: TextAlign.start,
                                        textScaleFactor: 1.2,
                                      ),
                                    ),
                                    utils.getRaisedButton(
                                        title: 'Available',
                                        onPressed: () {
                                          snapshot.reference.updateData({
                                            'isSold': false,
                                            'soldReason': null
                                          });
                                        }),
                                  ],
                                ),
                          SizedBox(height: 50),
                        ],
                      ),
                      Positioned(
                        bottom: -1,
                        right: 0,
                        left: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: utils.materialButton(
                                color: Colors.red.shade500,
                                title: 'Delete',
                                onPressed: () => deleteProduct(snapshot),
                              ),
                            ),
                            Expanded(
                              child: utils.materialButton(
                                color: Colors.grey.shade500,
                                title: 'Edit',
                                onPressed: () => editProduct(snapshot),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }

  deleteProduct(DocumentSnapshot snapshot) async {
    loading = true;
    handleState();
    await Future.forEach(snapshot.data['images'], (element) async {
      try {
        StorageReference ref =
            await firebaseStorage.getReferenceFromUrl(element);
        await ref.delete();
      } catch (e) {
        utils.showSnackbar(e.toString());
      }
    });
    await firestore
        .collection('products')
        .document(snapshot.documentID)
        .delete();
    Get.back();
  }

  editProduct(snapshot) {
    //Get.to(EditDataScreen(), arguments: snapshot);
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
