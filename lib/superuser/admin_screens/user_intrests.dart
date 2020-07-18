import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/superuser/admin_screens/intrest_info.dart';
import 'package:superuser/utils.dart';
import 'package:superuser/widgets/network_image.dart';

class UserIntrests extends StatefulWidget {
  @override
  _UserIntrestsState createState() => _UserIntrestsState();
}

class _UserIntrestsState extends State<UserIntrests> {
  Utils utils = Utils();
  Firestore firestore = Firestore.instance;
  Stream interestsStream;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.getAppbar('Interests'),
      body: utils.getContainer(
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('interested').snapshots(),
          builder: (context, interestsnap) {
            if (interestsnap.hasData) {
              if (interestsnap.data.documents.length == 0) {
                return utils.getNullWidget('No interests found !');
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: interestsnap.data.documents.length,
                  itemBuilder: (BuildContext context, int interestindex) {
                    return StreamBuilder<DocumentSnapshot>(
                        stream: firestore
                            .collection('customers')
                            .document(interestsnap
                                .data.documents[interestindex].documentID)
                            .snapshots(),
                        builder: (context, customersnap) {
                          if (customersnap.hasData) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: interestsnap
                                  .data
                                  .documents[interestindex]['interested']
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: firestore
                                        .collection('products')
                                        .document(
                                          interestsnap
                                                  .data.documents[interestindex]
                                              ['interested'][index],
                                        )
                                        .snapshots(),
                                    builder: (context, productsnap) {
                                      if (productsnap.hasData) {
                                        Map dataMap = productsnap.data.data;
                                        try {
                                          return utils.listTile(
                                            title:
                                                '${customersnap.data['name']} is interested in ${dataMap['title']}',
                                            leading: SizedBox(
                                              width: 70,
                                              child: PNetworkImage(
                                                productsnap.data['images'][0],
                                                fit: BoxFit.fitHeight,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => IntrestInfo(
                                                    usersnap: customersnap.data,
                                                    productsnap:
                                                        productsnap.data,
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        } catch (e) {
                                          return utils.listTile(
                                            leading: SizedBox(
                                              width: 70,
                                              child: Icon(MdiIcons.alertOutline,
                                                  color: Colors.red),
                                            ),
                                            title: '404 Product Not Found !',
                                            isTrailingNull: true,
                                          );
                                        }
                                      } else {
                                        return SizedBox();
                                      }
                                    });
                              },
                            );
                          } else {
                            return SizedBox();
                          }
                        });
                  },
                );
              }
            } else {
              return utils.getLoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
