import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/utils.dart';

class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return utils.getContainer(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('reuests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return utils.getNullWidget('No Orders Yet !');
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return;
                },
              );
            }
          } else {
            return utils.getLoadingIndicator();
          }
        },
      ),
    );
  }
}
