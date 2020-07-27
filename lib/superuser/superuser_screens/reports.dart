import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superuser/utils.dart';

class Reports extends StatefulWidget {
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return utils.container(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('reports').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return utils.nullWidget('No Reports Generated Yet !');
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                },
              );
            }
          } else {
            return utils.progressIndicator();
          }
        },
      ),
    );
  }
}
