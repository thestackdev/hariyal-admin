import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

import 'order_details.dart';

class Orders extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'Orders',
        child: controllers.utils.streamBuilder<QuerySnapshot>(
            stream: controllers.firestore
                .collection('orders')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (streamContext, oSnap) {
              return oSnap == null
                  ? controllers.utils.loading()
                  : oSnap.documents.length <= 0
                      ? controllers.utils.error('No Orders Yet')
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: oSnap.documents.length,
                          itemBuilder: (listContext, index) {
                            return controllers.utils
                                .streamBuilder<DocumentSnapshot>(
                                    stream: controllers.firestore
                                        .collection('orders')
                                        .document(
                                            oSnap.documents[index].documentID)
                                        .snapshots(),
                                    builder: (streamContext2, pSnap) {
                                      try {
                                        return pSnap == null
                                            ? controllers.utils.loading()
                                            : buildUI(oSnap, index);
                                      } catch (e) {
                                        return controllers.utils
                                            .error('Something went wrong');
                                      }
                                    });
                          });
            }),
      );

  Widget buildUI(QuerySnapshot oSnap, index) {
    return Container(
      height: 120,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: StreamBuilder<DocumentSnapshot>(
        stream: controllers.firestore
            .collection('products')
            .document(oSnap.documents[index].data['pid'])
            .snapshots(),
        builder: (streamContext2, pSnap) {
          var date = new DateTime.fromMillisecondsSinceEpoch(
              oSnap.documents[index]['timeStamp']);
          return pSnap != null && pSnap.hasData
              ? GestureDetector(
                  onTap: () {
                    Get.to(OrderDetails(oSnap.documents[index].documentID));
                  },
                  child: Card(
                    elevation: 6,
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            width: 120,
                            child: oSnap.documents[index].data['oStatus'] == 0
                                ? Image.asset('assets/booked.png')
                                : oSnap.documents[index].data['oStatus'] == 1
                                    ? Image.asset('assets/delivered.png')
                                    : oSnap.documents[index].data['oStatus'] ==
                                            2
                                        ? Image.asset('assets/cancelled.png')
                                        : Image.asset('assets/booked.png'),
                          ),
                          Flexible(
                            child: ListTile(
                              title: Text(pSnap.data['title'] == null
                                  ? ''
                                  : pSnap.data['title']),
                              subtitle: Text(
                                  'Booked date ${date.day}/${date.month}/${date.year}'),
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : controllers.utils.loading();
        },
      ),
    );
  }
}
