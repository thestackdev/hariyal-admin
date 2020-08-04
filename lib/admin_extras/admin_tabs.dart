import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/product_details.dart';
import 'package:superuser/widgets/image_view.dart';

class AdminExtras extends StatelessWidget {
  final String adminUid = Get.arguments;
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: controllers.utils.appbar(
          'Admin Extras',
          bottom: TabBar(
            labelStyle: controllers.utils.textStyle(fontSize: 18),
            indicatorColor: Colors.transparent,
            tabs: <Widget>[Tab(text: 'Products'), Tab(text: 'Details')],
          ),
        ),
        body: controllers.utils.container(
          child: TabBarView(
            children: <Widget>[
              controllers.utils.buildProducts(
                  query: controllers.products
                      .orderBy('timestamp', descending: true)
                      .where('author', isEqualTo: adminUid),
                  itemBuilder: (index, context, snapshot) {
                    try {
                      return controllers.utils.card(
                        title: snapshot.data['title'],
                        description: snapshot.data['description'],
                        imageUrl: snapshot.data['images'][0],
                        onTap: () => Get.to(
                          ProductDetails(),
                          arguments: snapshot.documentID,
                        ),
                      );
                    } catch (e) {
                      return controllers.utils.nullWidget(e.toString());
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
      stream: controllers.admin.document(adminUid).snapshots(),
      builder: (context, snapshot) {
        return ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (snapshot.data['imageUrl'] != null) {
                  Get.to(HariyalImageView(imageUrls: [snapshot['imageUrl']]));
                }
              },
              child: Container(
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.all(18),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    maxRadius: 90,
                    minRadius: 90,
                    backgroundImage: snapshot.data['imageUrl'] == null
                        ? AssetImage('assets/avatar-default-circle.png')
                        : CachedNetworkImageProvider(
                            snapshot['imageUrl'],
                          ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(9),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey.shade100,
              ),
              child: SwitchListTile(
                title: Text('Admin'),
                onChanged: controllers.firebaseUser.value.uid == adminUid ||
                        snapshot.data['isSuperuser'] == true
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
                onChanged: controllers.firebaseUser.value.uid == adminUid ||
                        snapshot.data['isAdmin'] == false
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
