import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class SoldItems extends StatelessWidget {
  final Query query;
  const SoldItems({Key key, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllers = Controllers.to;
    return Scaffold(
      appBar: controllers.utils.appbar('Sold Items'),
      body: controllers.utils.container(
        child: controllers.utils.buildProducts(
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
              return controllers.utils.nullWidget(e.toString());
            }
          },
        ),
      ),
    );
  }
}
