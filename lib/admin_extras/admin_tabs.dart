import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

class AdminExtras extends StatefulWidget {
  final adminUid;

  const AdminExtras({Key key, this.adminUid}) : super(key: key);

  @override
  _AdminExtrasState createState() => _AdminExtrasState();
}

class _AdminExtrasState extends State<AdminExtras> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: utils.appbar(
          'Admin Extras',
          boottom: utils.tabDecoration('Products', 'Privileges'),
        ),
        body: utils.container(
          child: TabBarView(
            children: <Widget>[
              ViewMyProducts(
                stream: Firestore.instance
                    .collection('admin')
                    .document(widget.adminUid)
                    .collection('products')
                    .orderBy('dateTime', descending: true)
                    .snapshots(),
              ),
              getPrivilages(),
            ],
          ),
        ),
      ),
    );
  }

  getPrivilages() {
    final uid = Provider.of<String>(context);
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('admin')
          .document(widget.adminUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.grey.shade100,
                ),
                child: SwitchListTile(
                  title: Text('Admin'),
                  onChanged: uid == widget.adminUid
                      ? null
                      : (value) {
                          snapshot.data.reference.updateData({
                            'isAdmin': !snapshot.data['isAdmin'],
                          });
                        },
                  value: snapshot.data['isAdmin'],
                ),
              ),
              Container(
                margin: EdgeInsets.all(9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                  color: Colors.grey.shade100,
                ),
                child: SwitchListTile(
                  title: Text('Superuser'),
                  onChanged: uid == widget.adminUid
                      ? null
                      : (value) {
                          snapshot.data.reference.updateData({
                            'isSuperuser': !snapshot.data['isSuperuser'],
                          });
                        },
                  value: snapshot.data['isSuperuser'],
                ),
              ),
            ],
          );
        } else {
          return utils.progressIndicator();
        }
      },
    );
  }
}
