import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/superuser/product_details.dart';

class AdminViewData extends StatefulWidget {
  final uid;

  const AdminViewData({Key key, this.uid}) : super(key: key);
  @override
  _AdminViewDataState createState() => _AdminViewDataState();
}

class _AdminViewDataState extends State<AdminViewData> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('admin')
          .document(widget.uid)
          .collection('products')
          .orderBy('dateTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(12),
                elevation: 4,
                shadowColor: Colors.deepPurple,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('products')
                          .document(snapshot.data.documents[index].documentID)
                          .snapshots(),
                      builder: (context, productSnap) {
                        if (productSnap.hasData) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetails(
                                    productSnap.data,
                                    widget.uid,
                                  ),
                                ),
                              );
                            },
                            leading: Image.network(
                              productSnap.data['images'][0],
                              height: 90,
                              width: 90,
                            ),
                            title: Text('${productSnap.data['title']}'),
                            subtitle:
                                Text('${productSnap.data['description']}'),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              );
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
