import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:superuser/admin_extras/admin_tabs.dart';
import 'package:superuser/utils.dart';

class Admins extends StatefulWidget {
  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return Scaffold(
      appBar: utils.appbar('Admins'),
      body: utils.container(
        child: DataStreamBuilder<QuerySnapshot>(
          errorBuilder: (context, error) => utils.nullWidget(error),
          loadingBuilder: (context) => utils.progressIndicator(),
          stream: Firestore.instance.collection('admin').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.documents.length == 0) {
              return utils.nullWidget('No Admins found !');
            } else {
              return ListView.builder(
                itemCount: snapshot.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Colors.grey.shade100,
                    ),
                    child: utils.listTile(
                      title: snapshot.documents[index]['name'],
                      subtitle:
                          'Since ${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.documents[index]['since']), format: AmericanDateFormats.dayOfWeek)}',
                      onTap: () => Get.to(
                        AdminExtras(
                          adminUid: snapshot.documents[index].documentID,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
