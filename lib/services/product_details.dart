import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/mark_as_sold.dart';
import 'package:superuser/widgets/image_slider.dart';
import 'package:superuser/widgets/image_view.dart';

import 'edit_data_screen.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  final controllers = Controllers.to;
  bool loading = false;
  final String docId = Get.arguments;
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'Product Details',
        child: loading
            ? controllers.utils.loading()
            : controllers.utils.streamBuilder(
                stream: controllers.products.document(docId).snapshots(),
                builder: (context, snapshot) {
                  Widget buildButton(int count, String label, Color color,
                          Function onTap) =>
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          padding: EdgeInsets.all(3),
                          height: MediaQuery.of(context).size.height * .07,
                          width: MediaQuery.of(context).size.width / count,
                          color: color,
                          alignment: Alignment.center,
                          child: Text(label, style: Get.textTheme.headline1),
                        ),
                      );

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
                          buildDetails('Author', snapshot.data['author']),
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
                          if (snapshot.data['reject_reason'] != null) ...[
                            SizedBox(height: 18),
                            buildDetails(
                              'Reject Reason',
                              snapshot.data['reject_reason'],
                            ),
                          ],
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
                            controllers.utils.raisedButton('Mark as Sold',
                                () => Get.to(MarkAsSold(), arguments: snapshot))
                          ] else if (snapshot.data['isSold'] == true) ...[
                            buildDetails(
                                'Sold Reason', snapshot.data['soldReason']),
                            SizedBox(height: 18),
                            buildDetails(
                              'Sold Date',
                              DateFormat.yMMMd().format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                  snapshot['sold_timestamp'],
                                ),
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
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Row(
                          children: <Widget>[
                            if (controllers.isSuperuser.value) ...[
                              if (!snapshot.data['authored']) ...[
                                buildButton(
                                  3,
                                  'Approve',
                                  Colors.green.shade500,
                                  () => snapshot.reference.updateData({
                                    'authored': true,
                                    'rejected': false,
                                    'reject_reason': null,
                                  }),
                                ),
                                buildButton(3, 'Edit', Colors.grey.shade500,
                                    () => editProduct(snapshot)),
                                buildButton(
                                  3,
                                  'Reject',
                                  Colors.redAccent,
                                  () => controllers.utils.getSimpleDialouge(
                                    title: 'Mention Reason ',
                                    content: controllers.utils.inputTextField(
                                      label: 'Reason',
                                      controller: controller,
                                    ),
                                    yesText: 'Reject',
                                    noText: 'Cancel',
                                    yesPressed: () => {
                                      Get.back(),
                                      snapshot.reference.updateData({
                                        'rejected': true,
                                        'reject_reason': controller.text.trim()
                                      }),
                                    },
                                    noPressed: () => Get.back(),
                                  ),
                                ),
                              ] else if (!snapshot.data['isSold']) ...[
                                buildButton(2, 'Edit', Colors.grey.shade500,
                                    () => editProduct(snapshot)),
                                buildButton(
                                  2,
                                  'Delete',
                                  Colors.redAccent,
                                  () => controllers.utils
                                      .getSimpleDialougeForNoContent(
                                    title: 'Delete this product ?',
                                    yesPressed: () => deleteProduct(snapshot),
                                    noPressed: () => Get.back(),
                                  ),
                                ),
                              ]
                            ] else if (!snapshot.data['authored']) ...[
                              if (snapshot.data['rejected']) ...[
                                buildButton(3, 'Edit', Colors.grey.shade500,
                                    () => editProduct(snapshot)),
                                buildButton(
                                  3,
                                  'Delete',
                                  Colors.redAccent,
                                  () => controllers.utils
                                      .getSimpleDialougeForNoContent(
                                    title: 'Delete this product permanently ?',
                                    yesPressed: () =>
                                        deletePremanently(snapshot),
                                    noPressed: () => Get.back(),
                                  ),
                                ),
                                buildButton(
                                  3,
                                  'Request Again',
                                  Colors.green.shade500,
                                  () => snapshot.reference
                                      .updateData({'rejected': false}),
                                ),
                              ] else if (!snapshot.data['isSold']) ...[
                                buildButton(
                                  2,
                                  'Delete',
                                  Colors.redAccent,
                                  () => controllers.utils
                                      .getSimpleDialougeForNoContent(
                                    title: 'Delete this product permanently ?',
                                    yesPressed: () =>
                                        deletePremanently(snapshot),
                                    noPressed: () => Get.back(),
                                  ),
                                ),
                                buildButton(2, 'Edit', Colors.grey.shade500,
                                    () => editProduct(snapshot))
                              ],
                            ],
                          ],
                        ),
                      ),
                    ],
                  );
                }),
      );

  Widget buildDetails(String key, String value) {
    try {
      return SelectableText.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '$key : ',
                style: Get.textTheme.headline3
                    .apply(fontSizeFactor: 1.2, color: Colors.redAccent)),
            TextSpan(text: value, style: Get.textTheme.headline3),
          ],
        ),
      );
    } catch (e) {
      Get.offNamed('errorPage');
      return null;
    }
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
