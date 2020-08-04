import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Pending extends StatelessWidget {
  final controllers = Controllers.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Pending'),
      body: controllers.utils.container(
        child: controllers.utils.buildProducts(
          query: controllers.products
              .orderBy('timestamp', descending: true)
              .where('author', isEqualTo: controllers.firebaseUser.value.uid)
              .where('authored', isEqualTo: false),
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
