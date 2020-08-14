import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Rejected extends StatelessWidget {
  final controllers = Controllers.to;
  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Pending',
      child: controllers.utils.streamBuilder(
        stream: controllers.products
            .orderBy('timestamp', descending: true)
            .where('author', isEqualTo: controllers.firebaseUser.value.uid)
            .where('authored', isEqualTo: false)
            .where('rejected', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.documents.length == 0) {
            return controllers.utils.error('No Products Rejected !');
          }
          try {
            return ListView.builder(
              itemCount: snapshot.documents.length,
              itemBuilder: (context, index) {
                return controllers.utils.card(
                  title: snapshot.documents[index].data['title'],
                  description: snapshot.documents[index].data['description'],
                  imageUrl: snapshot.documents[index].data['images'][0],
                  onTap: () => Get.toNamed(
                    'product_details',
                    arguments: snapshot.documents[index].documentID,
                  ),
                );
              },
            );
          } catch (e) {
            return controllers.utils.error('Oops.., Something went wrong');
          }
        },
      ),
    );
  }
}
