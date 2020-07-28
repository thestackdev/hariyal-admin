import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:superuser/utils.dart';
import 'package:provider/provider.dart';

class Requests extends StatelessWidget {
  final CollectionReference requests =
      Firestore.instance.collection('requests');

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return utils.container(
      child: DataStreamBuilder<QuerySnapshot>(
        loadingBuilder: (context) => utils.progressIndicator(),
        errorBuilder: (context, error) => utils.nullWidget(error.toString()),
        stream: requests.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.documents.length == 0) {
            return utils.nullWidget('No Pending Requests !');
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
    );
  }
}
