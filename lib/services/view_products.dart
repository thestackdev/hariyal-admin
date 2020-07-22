import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:superuser/superuser/product_details.dart';
import 'package:superuser/utils.dart';

class ViewMyProducts extends StatefulWidget {
  final Stream stream;

  const ViewMyProducts({Key key, this.stream}) : super(key: key);

  @override
  _ViewMyProductsState createState() => _ViewMyProductsState();
}

class _ViewMyProductsState extends State<ViewMyProducts> {
  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return DataStreamBuilder<QuerySnapshot>(
      stream: widget.stream,
      errorBuilder: (context, error) => utils.nullWidget(error),
      loadingBuilder: (context) => utils.progressIndicator(),
      builder: (context, snapshot) {
        if (snapshot.documents.length == 0) {
          return utils.nullWidget('No products found !');
        } else {
          return ListView.builder(
            itemCount: snapshot.documents.length,
            itemBuilder: (context, index) {
              try {
                return utils.productCard(
                  title: snapshot.documents[index].data['title'],
                  description: snapshot.documents[index].data['description'],
                  imageUrl: snapshot.documents[index].data['images'][0],
                  onTap: () => Get.to(ProductDetails(
                      docID: snapshot.documents[index].documentID)),
                );
              } catch (e) {
                return utils.errorListTile();
              }
            },
          );
        }
      },
    );
  }
}
