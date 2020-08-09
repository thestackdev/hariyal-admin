import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class SoldItems extends StatelessWidget {
  final Query query;
  const SoldItems({this.query});

  @override
  Widget build(BuildContext context) {
    final controllers = Controllers.to;
    return controllers.utils.root(
      label: 'Sold Items',
      child: controllers.utils.paginator(
        query: query,
        itemBuilder: (index, context, snapshot) {
          try {
            return controllers.utils.card(
              title: snapshot.data['title'],
              description: snapshot.data['description'],
              imageUrl: snapshot.data['images'][0],
              onTap: () => Get.toNamed(
                'product_details',
                arguments: snapshot.documentID,
              ),
            );
          } catch (e) {
            return controllers.utils.error('Oops.., Something went wrong !');
          }
        },
      ),
    );
  }
}
