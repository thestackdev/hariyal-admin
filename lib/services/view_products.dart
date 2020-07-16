import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/superuser/product_details.dart';
import 'package:superuser/utils.dart';

Utils utils = Utils();

getViewProducts(uid) {
  return StreamBuilder<QuerySnapshot>(
    stream: Firestore.instance
        .collection('admin')
        .document(uid)
        .collection('products')
        .orderBy('dateTime', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        if (snapshot.data.documents.length == 0) {
          return utils.getNullWidget('No products found !');
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              try {
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
                                    uid,
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
                          return utils.getLoadingIndicator();
                        }
                      },
                    ),
                  ),
                );
              } catch (e) {
                return Container(
                  margin: EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.grey.shade100,
                  ),
                  child: ListTile(
                    title: utils.getNullWidget('404 Product not found !'),
                  ),
                );
              }
            },
          );
        }
      } else {
        return utils.getLoadingIndicator();
      }
    },
  );
}
