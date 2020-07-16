import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/utils.dart';

class SoldItems extends StatefulWidget {
  @override
  _SoldItemsState createState() => _SoldItemsState();
}

class _SoldItemsState extends State<SoldItems> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: utils.getBoxDecoration(),
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('soldItems').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return utils.getNullWidget('No sold items found !');
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
