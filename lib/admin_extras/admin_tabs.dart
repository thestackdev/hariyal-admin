import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/product_details.dart';
import 'package:superuser/widgets/image_view.dart';

class AdminExtras extends StatelessWidget {
  final String adminUid = Get.arguments;
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: controllers.utils.root(
          label: 'Admin Extras',
          bottom: TabBar(
            tabs: <Widget>[Tab(text: 'Products'), Tab(text: 'Details')],
          ),
          child: TabBarView(
            children: <Widget>[
              controllers.utils.paginator(
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
                      return controllers.utils.error(e.toString());
                    }
                  }),
              getPrivilages(),
            ],
          ),
        ),
      );

  getPrivilages() => controllers.utils.streamBuilder(
        stream: controllers.admin.document(adminUid).snapshots(),
        builder: (context, snapshot) => Padding(
          padding: const EdgeInsets.all(9),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (snapshot.data['imageUrl'] != null) {
                    Get.to(HariyalImageView(imageUrls: [snapshot['imageUrl']]));
                  }
                },
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
              SwitchListTile(
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
              SwitchListTile(
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
            ],
          ),
        ),
      );
}
