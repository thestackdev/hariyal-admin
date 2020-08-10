import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class AllProducts extends StatelessWidget {
  final Query query;

  const AllProducts({Key key, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllers = Controllers.to;
    return controllers.utils.root(
      label: 'All Products',
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query': Controllers.to.products,
              'searchField': FieldPath.documentId,
              'type': 'product'
            };
            Get.toNamed('search', arguments: map);
          },
        )
      ],
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
            return controllers.utils.error(e.toString());
          }
        },
      ),
    );
  }
}
