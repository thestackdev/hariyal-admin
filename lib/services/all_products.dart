import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/search_page.dart';

class AllProducts extends StatelessWidget {
  final Query query;

  const AllProducts({Key key, this.query}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controllers = Controllers.to;
    return Scaffold(
      appBar: controllers.utils.appbar('All Products', actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query':
                  Controllers.to.products.where('isSold', isEqualTo: false),
              'searchField': FieldPath.documentId,
              'type': 'product'
            };
            Get.to(SearchPage(), arguments: map);
          },
        )
      ]),
      body: controllers.utils.container(
        child: controllers.utils.buildProducts(
          shrinkWrap: true,
          query: query,
          itemBuilder: (context, snapshot) {
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
