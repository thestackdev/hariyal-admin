import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/services/mark_as_sold.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/image_slider.dart';
import 'package:superuser/widgets/image_view.dart';
import 'package:intl/intl.dart';
import 'edit_data_screen.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final utils = Utils();
  bool loading = false;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final products = Firestore.instance.collection('products');
  final String docId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Product Details'),
      body: utils.container(
        child: loading
            ? utils.progressIndicator()
            : DataStreamBuilder<DocumentSnapshot>(
                errorBuilder: (context, error) => utils.nullWidget(),
                loadingBuilder: (context) => utils.progressIndicator(),
                stream: products.document(docId).snapshots(),
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
                          SizedBox(height: 18),
                          Row(
                            children: <Widget>[
                              Text(
                                'Product ID : ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
                              SelectableText(
                                '${snapshot.documentID}',
                                textAlign: TextAlign.justify,
                                style: utils.inputTextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: <Widget>[
                              Text(
                                'Category : ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
                              Text(
                                GetUtils.capitalizeFirst(
                                    '${snapshot.data['category']['category']}'),
                                textAlign: TextAlign.justify,
                                style: utils.inputTextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: <Widget>[
                              Text(
                                'Sub-Category : ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
                              Text(
                                GetUtils.capitalizeFirst(
                                    '${snapshot.data['category']['subCategory']}'),
                                textAlign: TextAlign.justify,
                                style: utils.inputTextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: <Widget>[
                              Text(
                                'State : ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
                              Text(
                                GetUtils.capitalizeFirst(
                                    '${snapshot.data['location']['state']}'),
                                textAlign: TextAlign.justify,
                                style: utils.inputTextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: <Widget>[
                              Text(
                                'Area : ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
                              Text(
                                GetUtils.capitalizeFirst(
                                    '${snapshot.data['location']['area']}'),
                                textAlign: TextAlign.justify,
                                style: utils.inputTextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Row(
                            children: <Widget>[
                              Text(
                                'Title : ',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 9),
                              Text(
                                GetUtils.capitalizeFirst(
                                    '${snapshot.data['title']}'),
                                textAlign: TextAlign.justify,
                                style: utils.inputTextStyle(),
                              ),
                            ],
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Description',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            GetUtils.capitalizeFirst(
                                '${snapshot.data['description']}'),
                            textAlign: TextAlign.justify,
                            style: utils.inputTextStyle(),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Price',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 9),
                          Text(
                            NumberFormat("#,##0.00", "en_US").format(
                              snapshot.data['price'],
                            ),
                            textAlign: TextAlign.justify,
                            style: utils.inputTextStyle(),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Specifications',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
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
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    snapshot.data['specifications']
                                        [keys[index]],
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 18,
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 18),
                          if (snapshot.data['isSold'] == false) ...[
                            utils.getRaisedButton(
                                title: 'Mark as sold',
                                onPressed: () =>
                                    Get.to(MarkAsSold(), arguments: snapshot))
                          ] else if (snapshot.data['isSold'] == true) ...[
                            Text(
                              'Sold Reason',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 9),
                            Text(
                              snapshot.data['soldReason'] ??=
                                  'Something went wrong',
                              textAlign: TextAlign.justify,
                              style: utils.inputTextStyle(),
                            ),
                            utils.getRaisedButton(
                                title: 'Mark as Available',
                                onPressed: () {
                                  snapshot.reference.updateData({
                                    'isSold': false,
                                    'soldReason': null,
                                  });
                                }),
                          ],
                          SizedBox(height: 50),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: utils.materialButton(
                                color: Colors.red.shade500,
                                title: 'Delete',
                                onPressed: () => utils.getSimpleDialouge(
                                  title: 'Are you sure',
                                  content: Text(
                                    'Do you want to delete this product ?',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  yesText: 'Delete',
                                  noText: 'Cancel',
                                  yesPressed: () => deleteProduct(snapshot),
                                  noPressed: () => Get.back(),
                                ),
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
    Get.back();
    products.document(snapshot.documentID).updateData({'isdeleted': true});
    Get.back();
  }

  editProduct(snapshot) => Get.to(EditDataScreen(), arguments: snapshot);

  handleState() => (mounted) ? setState(() => null) : null;
}
