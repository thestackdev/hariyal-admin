import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final controllers = Controllers.to;
  final filters = ['All Products', 'Sold Items'];
  List<Query> queryList = [];
  Query query;
  int selectedFilter = 0;

  @override
  void initState() {
    if (!controllers.isSuperuser.value) {
      queryList = [
        controllers.products
            .orderBy('timestamp', descending: true)
            .where('isDeleted', isEqualTo: false)
            .where('authored', isEqualTo: true)
            .where('isSold', isEqualTo: false),
        controllers.products
            .orderBy('timestamp', descending: true)
            .where('isDeleted', isEqualTo: false)
            .where('authored', isEqualTo: true)
            .where('isSold', isEqualTo: true),
      ];
    } else {
      final uid = controllers.firebaseUser.value.uid;
      queryList = [
        controllers.products
            .orderBy('timestamp', descending: true)
            .where('author', isEqualTo: uid)
            .where('isDeleted', isEqualTo: false)
            .where('authored', isEqualTo: true)
            .where('isSold', isEqualTo: false),
        controllers.products
            .orderBy('timestamp', descending: true)
            .where('author', isEqualTo: uid)
            .where('isDeleted', isEqualTo: false)
            .where('authored', isEqualTo: true)
            .where('isSold', isEqualTo: true),
      ];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
        label: filters[selectedFilter],
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Map<dynamic, dynamic> map = {
                'query': Controllers.to.products,
                'searchField': FieldPath.documentId,
                'type': 'product'
              };
              Get.toNamed('search', arguments: map);
            },
          ),
          IconButton(
            icon: Icon(OMIcons.filterList),
            onPressed: () {
              Get.bottomSheet(
                Container(
                  height: 180,
                  color: Colors.white,
                  child: ListView(
                    children: [
                      ListTile(
                        onTap: () {
                          setState(() => selectedFilter = 0);
                          Get.back();
                        },
                        leading: selectedFilter == 0
                            ? Icon(OMIcons.check, color: Colors.green)
                            : SizedBox(width: 30),
                        title: Text(filters[0], style: Get.textTheme.headline4),
                      ),
                      ListTile(
                        onTap: () {
                          setState(() => selectedFilter = 1);
                          Get.back();
                        },
                        leading: selectedFilter == 1
                            ? Icon(OMIcons.check, color: Colors.green)
                            : SizedBox(width: 30),
                        title: Text(filters[1], style: Get.textTheme.headline4),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
        child: ListView(
          children: [
            if (selectedFilter == 0) ...[
              controllers.utils.paginator(
                query: queryList[selectedFilter],
                itemBuilder: (index, context, snapshot) {
                  try {
                    return controllers.utils.card(
                      title: snapshot['title'],
                      description: snapshot['description'],
                      imageUrl: snapshot['images'][0],
                      onTap: () => Get.toNamed(
                        'product_details',
                        arguments: snapshot.documentID,
                      ),
                    );
                  } catch (e) {
                    return controllers.utils.error('Something went wrong');
                  }
                },
              ),
            ] else ...[
              controllers.utils.streamBuilder<QuerySnapshot>(
                stream: queryList[selectedFilter].snapshots(),
                builder: (context, snapshot) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      try {
                        return controllers.utils.card(
                          title: snapshot.documents[index]['title'],
                          description: snapshot.documents[index]['description'],
                          imageUrl: snapshot.documents[index]['images'][0],
                          onTap: () => Get.toNamed(
                            'product_details',
                            arguments: snapshot.documents[index].documentID,
                          ),
                        );
                      } catch (e) {
                        return controllers.utils.error('Something went wrong');
                      }
                    },
                  );
                },
              ),
            ]
          ],
        ));
  }
}
