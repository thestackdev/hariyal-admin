import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../utils.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = SearchBarController<DocumentSnapshot>();
  final Map map = Get.arguments;
  final utils = Utils();
  Query query;
  dynamic searchField;
  String type;
  final textStyle = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.grey.shade700, fontSize: 18);

  @override
  void initState() {
    query = map['query'];
    searchField = map['searchField'];
    type = map['type'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SearchBar<DocumentSnapshot>(
            searchBarStyle: SearchBarStyle(
              borderRadius: BorderRadius.circular(9),
            ),
            loader: utils.blankScreenLoading(),
            hintText: 'Search...',
            onError: (error) => Center(
                  child: Text('Something went wrong', style: textStyle),
                ),
            searchBarPadding: EdgeInsets.symmetric(horizontal: 9),
            headerPadding: EdgeInsets.symmetric(horizontal: 9),
            listPadding: EdgeInsets.symmetric(horizontal: 9),
            onSearch: onSearch,
            searchBarController: controller,
            placeHolder: Center(),
            cancellationWidget: Icon(MdiIcons.closeOutline),
            emptyWidget: Text('Nothing found', style: textStyle),
            onCancelled: () {},
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            crossAxisCount: 1,
            onItemFound: (snapshot, index) {
              try {
                switch (type) {
                  case 'product':
                    return utils.card(
                      title: snapshot.data['title'],
                      description: snapshot.data['description'],
                      imageUrl: snapshot.data['images'][0],
                      onTap: () => Get.offNamed(
                        'product_details',
                        arguments: snapshot.documentID,
                      ),
                    );
                    break;
                  case 'customer':
                    return utils.listTile(
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                          snapshot['image'],
                        ),
                      ),
                      title: '${snapshot['name']}',
                      onTap: () => Get.offNamed(
                        'customer_deatils',
                        arguments: snapshot,
                      ),
                    );
                  default:
                    return utils.errorListTile();
                }
              } catch (e) {
                return utils.errorListTile();
              }
            }),
      ),
    );
  }

  Future<List<DocumentSnapshot>> onSearch(String text) =>
      query.where(searchField, isEqualTo: text).getDocuments().then((value) {
        value.documents.forEach((element) {
          print(element.data);
        });
        return value.documents;
      });
}
