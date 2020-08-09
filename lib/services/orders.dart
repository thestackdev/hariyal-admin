import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/get/controllers.dart';

class Orders extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'Orders',
        child: controllers.utils.streamBuilder<QuerySnapshot>(
            stream: controllers.orders.snapshots(),
            builder: (context, snapshot) => (snapshot.documents.length == 0)
                ? controllers.utils.error('No Orders Pending !')
                : ListView.builder(
                    itemCount: snapshot.documents.length,
                    itemBuilder: (context, index) {
                      try {
                        return null;
                      } catch (e) {
                        return controllers.utils
                            .error('Oops.., Something went wrong');
                      }
                    },
                  )),
      );
}
