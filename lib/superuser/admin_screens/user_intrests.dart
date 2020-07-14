import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/superuser/admin_screens/intrest_info.dart';

class UserIntrests extends StatefulWidget {
  @override
  _UserIntrestsState createState() => _UserIntrestsState();
}

class _UserIntrestsState extends State<UserIntrests> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('interested').snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> interestsnap) {
        if (interestsnap.hasData) {
          return ListView.builder(
            itemCount: interestsnap.data.documents.length,
            itemBuilder: (BuildContext context, int interestindex) {
              return StreamBuilder<DocumentSnapshot>(
                  stream: Firestore.instance
                      .collection('customers')
                      .document(
                        interestsnap.data.documents[interestindex].documentID,
                      )
                      .snapshots(),
                  builder: (context, customersnap) {
                    if (customersnap.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: interestsnap
                            .data.documents[interestindex]['interests'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection('products')
                                  .document(
                                    interestsnap.data.documents[interestindex]
                                        ['interests'][index]['product_id'],
                                  )
                                  .snapshots(),
                              builder: (context, productsnap) {
                                if (productsnap.hasData) {
                                  return Container(
                                    margin: EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(9),
                                      color: Colors.grey.shade200,
                                    ),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => IntrestInfo(
                                                usersnap: customersnap.data,
                                                productsnap: productsnap.data),
                                          ),
                                        );
                                      },
                                      title: Text(
                                          '${customersnap.data['name']} is interested in ${productsnap.data['title']}'),
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              });
                        },
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
