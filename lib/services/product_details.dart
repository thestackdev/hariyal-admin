import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/mark_as_sold.dart';
import 'package:superuser/widgets/image_slider.dart';
import 'package:superuser/widgets/image_view.dart';
import 'package:intl/intl.dart';
import 'edit_data_screen.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final controllers = Controllers.to;
  bool loading = false;
  final String docId = Get.arguments;
  String admin = '';
  bool isFirst = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Product Details'),
      body: controllers.utils.container(
        child: loading
            ? controllers.utils.progressIndicator()
            : DataStreamBuilder<DocumentSnapshot>(
                stream: controllers.products.document(docId).snapshots(),
                builder: (context, snapshot) {
                  if (isFirst) {
                    controllers.admin
                        .document(snapshot.data['author'])
                        .get()
                        .then((value) {
                      admin = value.data['name'];
                      isFirst = false;
                      handleState();
                    });
                  }

                  Widget buildButton(
                      int count, String label, Color color, Function onTap) {
                    return GestureDetector(
                      onTap: onTap,
                      child: Container(
                        height: MediaQuery.of(context).size.height * .07,
                        width: MediaQuery.of(context).size.width / count,
                        color: color,
                        alignment: Alignment.center,
                        child: Text(
                          label,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }

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
                          buildDetails('Product ID', snapshot.documentID),
                          SizedBox(height: 18),
                          buildDetails('Category',
                              snapshot.data['category']['category']),
                          SizedBox(height: 18),
                          buildDetails('Sub-Category',
                              snapshot.data['category']['subCategory']),
                          SizedBox(height: 18),
                          buildDetails(
                              'State', snapshot.data['location']['state']),
                          SizedBox(height: 18),
                          buildDetails(
                              'Area', snapshot.data['location']['area']),
                          SizedBox(height: 18),
                          buildDetails('Title', snapshot.data['title']),
                          SizedBox(height: 18),
                          buildDetails(
                            'Added Date',
                            DateFormat.yMMMd().format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  snapshot['timestamp']),
                            ),
                          ),
                          SizedBox(height: 18),
                          buildDetails('Author', admin),
                          SizedBox(height: 18),
                          buildDetails(
                              'Description', snapshot.data['description']),
                          SizedBox(height: 18),
                          buildDetails(
                            'Price',
                            NumberFormat("#,##0.0", "en_US").format(
                              snapshot.data['price'],
                            ),
                          ),
                          SizedBox(height: 18),
                          Text(
                            'Specifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
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
                              return buildDetails(
                                keys[index],
                                snapshot.data['specifications'][keys[index]],
                              );
                            },
                          ),
                          SizedBox(height: 18),
                          if (snapshot.data['isSold'] == false &&
                              snapshot.data['authored']) ...[
                            Center(
                              child: RaisedButton(
                                child: Text('Mark as Sold'),
                                onPressed: () =>
                                    Get.to(MarkAsSold(), arguments: snapshot),
                              ),
                            )
                          ] else if (snapshot.data['isSold'] == true) ...[
                            buildDetails(
                                'Sold Reason', snapshot.data['soldReason']),
                            SizedBox(height: 18),
                            buildDetails(
                              'Sold Date',
                              DateFormat.yMMMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    snapshot['sold_timestamp']),
                              ),
                            ),
                            SizedBox(height: 18),
                            controllers.utils.raisedButton(
                              'Mark as Available',
                              () => snapshot.reference.updateData({
                                'isSold': false,
                                'soldReason': null,
                              }),
                            )
                          ],
                          SizedBox(height: 50),
                        ],
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        left: 0.0,
                        child: Row(
                          children: <Widget>[
                            if (!snapshot.data['authored']) ...[
                              if (!controllers.isSuperuser.value) ...[
                                buildButton(
                                  2,
                                  'Edit',
                                  Colors.grey.shade500,
                                  () => editProduct(snapshot),
                                ),
                                buildButton(
                                  2,
                                  'Delete',
                                  Colors.redAccent,
                                  () => controllers.utils.getSimpleDialouge(
                                    title: 'Are you sure',
                                    content: Text(
                                      'Delete this product permanently ?',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    yesText: 'Delete',
                                    noText: 'Cancel',
                                    yesPressed: () =>
                                        deletePremanently(snapshot),
                                    noPressed: () => Get.back(),
                                  ),
                                ),
                              ] else ...[
                                buildButton(
                                  3,
                                  'Approve',
                                  Colors.green.shade500,
                                  () => snapshot.reference
                                      .updateData({'authored': true}),
                                ),
                                buildButton(
                                  3,
                                  'Edit',
                                  Colors.grey.shade500,
                                  () => editProduct(snapshot),
                                ),
                                buildButton(
                                  3,
                                  'Reject',
                                  Colors.redAccent,
                                  () => controllers.utils.getSimpleDialouge(
                                    title: 'Are you sure',
                                    content: Text(
                                      'Do you want to Reject this product ?',
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 18,
                                      ),
                                    ),
                                    yesText: 'Reject',
                                    noText: 'Cancel',
                                    yesPressed: () =>
                                        deletePremanently(snapshot),
                                    noPressed: () => Get.back(),
                                  ),
                                ),
                              ],
                            ] else if (!snapshot.data['isDeleted'] &&
                                !snapshot.data['isSold']) ...[
                              buildButton(
                                2,
                                'Delete',
                                Colors.redAccent,
                                () => controllers.utils.getSimpleDialouge(
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
                              buildButton(
                                2,
                                'Edit',
                                Colors.grey.shade500,
                                () => editProduct(snapshot),
                              )
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }

  Widget buildDetails(String key, String value) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$key : ',
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  deletePremanently(DocumentSnapshot snapshot) {
    Get.back();
    final images = snapshot.data['images'];
    images.forEach((element) => controllers.firebaseStorage
        .getReferenceFromUrl(element)
        .then((value) => value.delete()));
    controllers.products.document(snapshot.documentID).delete();
    Get.back();
  }

  deleteProduct(DocumentSnapshot snapshot) async {
    Get.back();
    controllers.products
        .document(snapshot.documentID)
        .updateData({'isdeleted': true});
    Get.back();
  }

  editProduct(snapshot) => Get.to(EditDataScreen(), arguments: snapshot);

  handleState() => (mounted) ? setState(() => null) : null;
}
