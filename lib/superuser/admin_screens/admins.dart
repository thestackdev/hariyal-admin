import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';
import 'package:superuser/admin_extras/admin_tabs.dart';
import 'package:superuser/utils.dart';

class Admins extends StatefulWidget {
  const Admins({Key key}) : super(key: key);

  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Admins'),
      body: utils.container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('admin').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.documents.length == 0) {
                return utils.nullWidget('No Admins found !');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey.shade100,
                      ),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AdminExtras(
                                adminUid:
                                    snapshot.data.documents[index].documentID,
                              ),
                            ),
                          );
                        },
                        title: Text(
                          capitalize(snapshot.data.documents[index]['name']),
                          style: TextStyle(
                            color: Colors.red.shade300,
                          ),
                          textScaleFactor: 1.2,
                        ),
                        subtitle: Text(
                            'Since ${DateTimeFormat.format(DateTime.fromMillisecondsSinceEpoch(snapshot.data.documents[index]['since']), format: AmericanDateFormats.dayOfWeek)}'),
                      ),
                    );
                  },
                );
              }
            } else {
              return utils.progressIndicator();
            }
          },
        ),
      ),
    );
  }
}
