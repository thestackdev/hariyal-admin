import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/utils.dart';

class SoldItems extends StatelessWidget {
  final Query query;

  const SoldItems({Key key, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = Utils();
    return Scaffold(
      appBar: utils.appbar('Sold Items'),
      body: utils.container(
        child: utils.buildProducts(
          query: query,
          itemBuilder: (context, snapshot) {
            try {
              return utils.card(
                title: snapshot.data['title'],
                description: snapshot.data['description'],
                imageUrl: snapshot.data['images'][0],
                onTap: () => Get.toNamed(
                  'product_details',
                  arguments: snapshot.documentID,
                ),
              );
            } catch (e) {
              return utils.errorListTile();
            }
          },
        ),
      ),
    );
  }
}
