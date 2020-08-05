import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Rejected extends StatelessWidget {
  final controllers = Controllers.to;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Pending'),
      body: controllers.utils.container(
        child: DataStreamBuilder<QuerySnapshot>(
          stream: controllers.products
              .orderBy('timestamp', descending: true)
              .where('author', isEqualTo: controllers.firebaseUser.value.uid)
              .where('rejected', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.documents.length == 0) {
              return controllers.utils.nullWidget('No Products Found');
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
              return controllers.utils.nullWidget(e.toString());
            }
          },
        ),
      ),
    );
  }
}
