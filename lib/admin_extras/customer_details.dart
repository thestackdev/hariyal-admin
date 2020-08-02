import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/product_details.dart';
import 'package:superuser/widgets/network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Customerdetails extends StatelessWidget {
  final controllers = Controllers.to;
  final DocumentSnapshot snapshot = Get.arguments;

  @override
  Widget build(BuildContext context) {
    void makeAPhone(String url) async {
      try {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          controllers.utils.showSnackbar('Something went wrong');
        }
      } catch (e) {
        controllers.utils.showSnackbar(e.toString());
      }
    }

    void writeAnEmail(String email) async {
      final Uri _emailLaunchUri = Uri(
          scheme: 'mailto',
          path: email,
          queryParameters: {'subject': 'Hariyal'});
      try {
        if (await canLaunch(_emailLaunchUri.toString())) {
          await launch(_emailLaunchUri.toString());
        } else {
          controllers.utils.showSnackbar('Something went wrong');
        }
      } catch (e) {
        controllers.utils.showSnackbar(e.toString());
      }
    }

    detailsPage() {
      return controllers.utils.container(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: controllers.utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  snapshot['name'] ?? 'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: controllers.utils.inputDecoration(label: 'Name'),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      style: controllers.utils.inputTextStyle(),
                      initialValue: GetUtils.capitalize(
                        snapshot['phone'] ?? 'Something went wrong !',
                      ),
                      readOnly: true,
                      maxLines: null,
                      decoration: controllers.utils.inputDecoration(
                        label: 'Phone',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    icon: Icon(OMIcons.phone),
                    onPressed: () => makeAPhone('tel: ${snapshot['phone']}'),
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
                      style: controllers.utils.inputTextStyle(),
                      initialValue:
                          snapshot['email'] ?? 'Something went wrong !',
                      readOnly: true,
                      maxLines: null,
                      decoration: controllers.utils.inputDecoration(
                        label: 'Email',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                      icon: Icon(OMIcons.email),
                      onPressed: () {
                        if (snapshot['email'] != 'default') {
                          writeAnEmail(
                            snapshot['email'],
                          );
                        } else {
                          controllers.utils
                              .showSnackbar('Invalid Email Address');
                        }
                      }),
                ),
                SizedBox(width: 18),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: controllers.utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  snapshot['gender'] ?? 'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: controllers.utils.inputDecoration(label: 'Gender'),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      style: controllers.utils.inputTextStyle(),
                      initialValue: GetUtils.capitalize(
                        snapshot['alternatePhoneNumber'] ??
                            'Something went wrong !',
                      ),
                      readOnly: true,
                      maxLines: null,
                      decoration: controllers.utils.inputDecoration(
                        label: 'Alternate Phone',
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                      icon: Icon(OMIcons.phone),
                      onPressed: () {
                        if (snapshot['alternatePhoneNumber'] != 'default') {
                          makeAPhone(
                              'tel: ${snapshot['alternatePhoneNumber']}');
                        } else {
                          controllers.utils.showSnackbar('No Phone Number');
                        }
                      }),
                ),
                SizedBox(width: 18),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: controllers.utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  snapshot['permanentAddress'] ?? 'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: controllers.utils
                    .inputDecoration(label: 'Permanent Address'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: controllers.utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  snapshot['location']['cityDistrict'] ??
                      'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration:
                    controllers.utils.inputDecoration(label: 'City/District'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12),
              child: TextFormField(
                style: controllers.utils.inputTextStyle(),
                initialValue: GetUtils.capitalize(
                  snapshot['location']['state'] ?? 'Something went wrong !',
                ),
                readOnly: true,
                maxLines: null,
                decoration: controllers.utils.inputDecoration(label: 'State'),
              ),
            ),
          ],
        ),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: controllers.utils.appbar(
          'Customer Console',
          bottom: TabBar(
            labelStyle: controllers.utils.textStyle(fontSize: 18),
            indicatorColor: Colors.transparent,
            tabs: <Widget>[Tab(text: 'Details'), Tab(text: 'Interests')],
          ),
        ),
        body: TabBarView(children: <Widget>[
          detailsPage(),
          controllers.utils.container(
              child: controllers.utils.buildProducts(
                  query: controllers.interests
                      .orderBy('timestamp', descending: true)
                      .where('author', isEqualTo: snapshot.documentID),
                  itemBuilder: (context, snapshot) {
                    return DataStreamBuilder<DocumentSnapshot>(
                        stream: controllers.products
                            .document(snapshot['productId'])
                            .snapshots(),
                        builder: (context, product) {
                          try {
                            return controllers.utils.listTile(
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
                            return controllers.utils.nullWidget(e.toString());
                          }
                        });
                  }))
        ]),
      ),
    );
  }
}
