import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/superuser/product_details.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Customerdetails extends StatefulWidget {
  final DocumentSnapshot docsnap;

  Customerdetails({Key key, this.docsnap}) : super(key: key);

  @override
  _CustomerdetailsState createState() => _CustomerdetailsState();
}

class _CustomerdetailsState extends State<Customerdetails> {
  CollectionReference products = Firestore.instance.collection('products');
  CollectionReference interests = Firestore.instance.collection('interests');
  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    void makeAPhone(String url) async {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          utils.showSnackbar('Something went wrong');
        }
      } catch (e) {
        utils.showSnackbar(e.toString());
      }
    }

    void writeAnEmail(String email) async {
      final Uri _emailLaunchUri = Uri(
          scheme: 'Mail From Hariyal',
          path: email,
          queryParameters: {'subject': 'Hariyal'});
      try {
        if (await canLaunch(_emailLaunchUri.toString())) {
          await launch(_emailLaunchUri.toString());
        } else {
          utils.showSnackbar('Something went wrong');
        }
      } catch (e) {
        utils.showSnackbar(e.toString());
      }
    }

    detailsPage() {
      return utils.container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  widget.docsnap['name'] ?? 'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: utils.inputDecoration(label: 'Name'),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      style: utils.inputTextStyle(),
                      initialValue: GetUtils.capitalize(
                        widget.docsnap['phone'] ?? 'Something went wrong !',
                      ),
                      readOnly: true,
                      maxLines: null,
                      decoration: utils.inputDecoration(
                        label: 'Phone',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    icon: Icon(MdiIcons.phoneOutline),
                    onPressed: () =>
                        makeAPhone('tel: ${widget.docsnap['phone']}'),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      style: utils.inputTextStyle(),
                      initialValue:
                          widget.docsnap['email'] ?? 'Something went wrong !',
                      readOnly: true,
                      maxLines: null,
                      decoration: utils.inputDecoration(
                        label: 'Email',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                      icon: Icon(MdiIcons.emailOutline),
                      onPressed: () {
                        if (widget.docsnap['email'] != 'default') {
                          writeAnEmail(
                            widget.docsnap['email'],
                          );
                        } else {
                          utils.showSnackbar('Invalid Email Address');
                        }
                      }),
                ),
                SizedBox(width: 18),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  widget.docsnap['gender'] ?? 'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: utils.inputDecoration(label: 'Gender'),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      style: utils.inputTextStyle(),
                      initialValue: GetUtils.capitalize(
                        widget.docsnap['alternatePhoneNumber'] ??
                            'Something went wrong !',
                      ),
                      readOnly: true,
                      maxLines: null,
                      decoration: utils.inputDecoration(
                        label: 'Alternate Phone',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                      icon: Icon(MdiIcons.phoneOutline),
                      onPressed: () {
                        if (widget.docsnap['alternatePhoneNumber'] !=
                            'default') {
                          makeAPhone(
                              'tel: ${widget.docsnap['alternatePhoneNumber']}');
                        } else {
                          utils.showSnackbar('No Phone Number');
                        }
                      }),
                ),
                SizedBox(width: 18),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  widget.docsnap['permanentAddress'] ??
                      'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: utils.inputDecoration(label: 'Permanent Address'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  widget.docsnap['location']['cityDistrict'] ??
                      'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: utils.inputDecoration(label: 'City/District'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  widget.docsnap['location']['state'] ??
                      'Something went wrong !',
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: utils.appbar(
          'Customer Console',
          bottom: utils.tabDecoration('Details', 'Interests'),
        ),
        body: TabBarView(
          children: <Widget>[
            detailsPage(),
            utils.container(
              child: DataStreamBuilder<QuerySnapshot>(
                  errorBuilder: (context, error) => utils.nullWidget(error),
                  loadingBuilder: (context) => utils.progressIndicator(),
                  stream: interests
                      .orderBy('timestamp', descending: true)
                      .where('author', isEqualTo: widget.docsnap.documentID)
                      .snapshots(),
                  builder: (context, interest) {
                    print(interest.documents.length);
                    if (interest.documents.length == 0 || interest == null) {
                      return utils.nullWidget('No interests found !');
                    } else {
                      return ListView.builder(
                          itemCount: interest.documents.length,
                          itemBuilder: (context, index) {
                            return DataStreamBuilder<DocumentSnapshot>(
                                errorBuilder: (context, error) =>
                                    utils.nullWidget(error),
                                loadingBuilder: (context) =>
                                    utils.progressIndicator(),
                                stream: products
                                    .document(
                                        interest.documents[index]['productId'])
                                    .snapshots(),
                                builder: (context, product) {
                                  try {
                                    return utils.listTile(
                                      title: '${product.data['title']}',
                                      leading: SizedBox(
                                        width: 70,
                                        child: PNetworkImage(
                                          product.data['images'][0],
                                          fit: BoxFit.fitHeight,
                                        ),
                                      ),
                                      onTap: () => Get.to(
                                        ProductDetails(),
                                        arguments: product.documentID,
                                      ),
                                    );
                                  } catch (e) {
                                    return utils.errorListTile();
                                  }
                                });
                          });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
