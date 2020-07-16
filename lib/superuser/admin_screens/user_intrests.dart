import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/superuser/admin_screens/intrest_info.dart';
import 'package:superuser/utils.dart';

class UserIntrests extends StatefulWidget {
  @override
  _UserIntrestsState createState() => _UserIntrestsState();
}

class _UserIntrestsState extends State<UserIntrests> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.getAppbar('Interests'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: utils.getBoxDecoration(),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('interested').snapshots(),
          builder: (context, interestsnap) {
            if (interestsnap.hasData) {
              if (interestsnap.data.documents.length == 0) {
                return utils.getNullWidget('No interests found');
              }
              return ListView.builder(
                itemCount: interestsnap.data.documents.length,
                itemBuilder: (BuildContext context, int interestindex) {
                  return StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('customers')
                          .document(
                            interestsnap
                                .data.documents[interestindex].documentID,
                          )
                          .snapshots(),
                      builder: (context, customersnap) {
                        if (customersnap.hasData) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: interestsnap.data
                                .documents[interestindex]['interested'].length,
                            itemBuilder: (BuildContext context, int index) {
                              return StreamBuilder<DocumentSnapshot>(
                                  stream: Firestore.instance
                                      .collection('products')
                                      .document(
                                        interestsnap
                                                .data.documents[interestindex]
                                            ['interested'][index],
                                      )
                                      .snapshots(),
                                  builder: (context, productsnap) {
                                    if (productsnap.hasData) {
                                      try {
                                        return Container(
                                          margin: EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: ListTile(
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
                                            title: Text(
                                              '${customersnap.data['name']} is interested in ${productsnap.data['title']}',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        return Container(
                                          margin: EdgeInsets.all(9),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: Colors.grey.shade100,
                                          ),
                                          child: ListTile(
                                            title: utils.getNullWidget(
                                              '404 Product not found !',
                                            ),
                                          ),
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
            } else {
              return utils.getLoadingIndicator();
            }
          },
        ),
      ),
    );
  }
}
