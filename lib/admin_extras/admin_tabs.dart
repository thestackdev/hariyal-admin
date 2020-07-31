import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/services/product_details.dart';
import 'package:superuser/utils.dart';

class AdminExtras extends StatefulWidget {
  final adminUid;

  const AdminExtras({Key key, this.adminUid}) : super(key: key);

  @override
  _AdminExtrasState createState() => _AdminExtrasState();
}

class _AdminExtrasState extends State<AdminExtras> {
  final Utils utils = Utils();
  Firestore firestore = Firestore.instance;
  String uid;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: utils.appbar(
          'Admin Extras',
          bottom: utils.tabDecoration('Products', 'Privileges'),
        ),
        body: utils.container(
          child: TabBarView(
            children: <Widget>[
              utils.buildProducts(
                  query: firestore
                      .collection('products')
                      .where('author', isEqualTo: widget.adminUid),
                  itemBuilder: (context, snapshot) {
                    try {
                      return utils.card(
                        title: snapshot.data['title'],
                        description: snapshot.data['description'],
                        imageUrl: snapshot.data['images'][0],
                        onTap: () => Get.to(
                          ProductDetails(),
                          arguments: snapshot.documentID,
                        ),
                      );
                    } catch (e) {
                      return utils.errorListTile();
                    }
                  }),
              getPrivilages(),
            ],
          ),
        ),
      ),
    );
  }

  getPrivilages() {
    return DataStreamBuilder<DocumentSnapshot>(
      errorBuilder: (context, error) => utils.nullWidget(error),
      loadingBuilder: (context) => utils.progressIndicator(),
      stream:
          firestore.collection('admin').document(widget.adminUid).snapshots(),
      builder: (context, snapshot) {
        return ListView(
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
                        snapshot.reference.updateData({
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
                        snapshot.reference.updateData({
                          'isSuperuser': !snapshot.data['isSuperuser'],
                        });
                      },
                value: snapshot.data['isSuperuser'],
              ),
            ),
          ],
        );
      },
    );
  }
}
