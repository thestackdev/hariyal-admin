import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:superuser/get/controllers.dart';

class Orders extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Orders'),
      body: controllers.utils.container(
        child: DataStreamBuilder<QuerySnapshot>(
          stream: controllers.orders.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.documents.length == 0) {
              return controllers.utils.nullWidget('Nothing Found');
            } else {
              return ListView.builder(
                itemCount: snapshot.documents.length,
                itemBuilder: (context, index) {
                  return;
                },
              );
            }
          },
        ),
      ),
    );
  }
}
