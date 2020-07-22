import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:strings/strings.dart';
import 'package:superuser/superuser/product_details.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/network_image.dart';

class Customerdetails extends StatefulWidget {
  final DocumentSnapshot docsnap;

  Customerdetails({Key key, this.docsnap}) : super(key: key);

  @override
  _CustomerdetailsState createState() => _CustomerdetailsState();
}

class _CustomerdetailsState extends State<Customerdetails> {
  Utils utils = new Utils();
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: utils.appbar(
          'Customer Console',
          boottom: utils.tabDecoration('Details', 'Interests'),
        ),
        body: TabBarView(
          children: <Widget>[
            detailsPage(),
            interestsPage(),
          ],
        ),
      ),
    );
  }

  detailsPage() {
    return utils.container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['name'] ?? 'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'Name'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['phone'] ?? 'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'Phone'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: widget.docsnap['email'] ?? 'Something went wrong !',
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'Email'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['gender'] ?? 'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'Gender'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['alternatePhoneNumber'] ??
                    'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'Alternate Phone'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['permanentAddress'] ?? 'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'Permanent Address'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['location']['cityDistrict'] ??
                    'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'City/District'),
            ),
          ),
          utils.textInputPadding(
            child: TextFormField(
              style: utils.inputTextStyle(),
              initialValue: capitalize(
                widget.docsnap['location']['state'] ?? 'Something went wrong !',
              ),
              readOnly: true,
              maxLines: null,
              decoration: utils.inputDecoration(label: 'State'),
            ),
          ),
        ],
      ),
    );
  }

  interestsPage() {
    return utils.container(
      child: DataStreamBuilder<DocumentSnapshot>(
          errorBuilder: (context, error) => utils.nullWidget(error),
          loadingBuilder: (context) => utils.progressIndicator(),
          stream: firestore
              .collection('interested')
              .document(widget.docsnap.documentID)
              .snapshots(),
          builder: (context, interestsnap) {
            if (interestsnap.data['interested'] == null ||
                interestsnap.data['interested'].length == 0) {
              return utils.nullWidget('No interests found !');
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: interestsnap.data['interested'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return DataStreamBuilder<DocumentSnapshot>(
                        errorBuilder: (context, error) =>
                            utils.nullWidget(error),
                        loadingBuilder: (context) => utils.progressIndicator(),
                        stream: firestore
                            .collection('products')
                            .document(
                              interestsnap.data['interested'][index],
                            )
                            .snapshots(),
                        builder: (context, productsnap) {
                          try {
                            return utils.listTile(
                              title: '${productsnap.data['title']}',
                              leading: SizedBox(
                                width: 70,
                                child: PNetworkImage(
                                  productsnap.data['images'][0],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                              onTap: () => Get.to(
                                ProductDetails(
                                  docID: interestsnap.data['interested'][index],
                                ),
                              ),
                            );
                          } catch (e) {
                            return utils.errorListTile();
                          }
                        });
                  });
            }
          }),
    );
  }
}
