import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/superuser/admin_screens/edit_data_screen.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/image_slider.dart';
import 'package:superuser/widgets/image_view.dart';

class ProductDetails extends StatefulWidget {
  final docID;

  const ProductDetails({Key key, this.docID}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Utils utils = Utils();
  bool loading = false;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Firestore firestore = Firestore.instance;

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
                    .document(widget.docID)
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
                            snapshot.data['title'],
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
                            '${snapshot.data['description']}',
                            textAlign: TextAlign.justify,
                            style: utils.inputTextStyle(),
                          ),
                          SizedBox(height: 9),
                          Container(
                            margin: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey.shade100,
                            ),
                            child: SwitchListTile(
                              title: Text(
                                snapshot.data['isSold']
                                    ? 'Mark as Available'
                                    : 'Mark as sold',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              value: snapshot.data['isSold'],
                              onChanged: (value) {
                                snapshot.reference
                                    .updateData({'isSold': value});
                              },
                            ),
                          ),
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

  deleteProduct(snapshot) async {
    loading = true;
    handleState();
    await Future.forEach(snapshot.data.data['images'], (element) async {
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
        .document(snapshot.data.documentID)
        .delete();
    await firestore
        .collection('admin')
        .document(snapshot.data.data['author'])
        .collection('products')
        .document(snapshot.data.documentID)
        .delete();
    Get.back();
  }

  editProduct(snapshot) {
    Get.to(EditDataScreen(productSnap: snapshot.data));
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
