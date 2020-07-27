import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:provider/provider.dart';
import 'package:superuser/utils.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  Firestore firestore = Firestore.instance;
  CollectionReference reports;

  @override
  void initState() {
    reports = firestore.collection('reports');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return utils.container(
      child: DataStreamBuilder<QuerySnapshot>(
        loadingBuilder: (context) => utils.progressIndicator(),
        errorBuilder: (context, error) => utils.nullWidget(error.toString()),
        stream: reports.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.documents.length == 0) {
            return utils.nullWidget('No Reports Generated Yet !');
          } else {
            return ListView.builder(
              itemCount: snapshot.documents.length,
              itemBuilder: (BuildContext context, int index) {
                return;
              },
            );
          }
        },
      ),
    );
  }
}
