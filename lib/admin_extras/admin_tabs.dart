import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

class AdminExtras extends StatefulWidget {
  final uid;

  const AdminExtras({Key key, this.uid}) : super(key: key);

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
        backgroundColor: Colors.red,
        appBar: utils.getAppbar(
          'Admin Extras',
          boottom: TabBar(
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            indicatorColor: Colors.transparent,
            tabs: [Tab(text: 'Products'), Tab(text: 'Privileges')],
          ),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: utils.getBoxDecoration(),
          child: TabBarView(
            children: <Widget>[
              getViewProducts(widget.uid),
              getPrivilages(),
            ],
          ),
        ),
      ),
    );
  }

  getPrivilages() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('admin')
          .document(widget.uid)
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
                  onChanged: (value) {
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
                  onChanged: (value) {
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
          return utils.getLoadingIndicator();
        }
      },
    );
  }
}
