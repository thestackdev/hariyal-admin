import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/superuser/product_details.dart';
import 'package:superuser/utils.dart';
import 'package:provider/provider.dart';

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  String text;
  final CollectionReference products =
      Firestore.instance.collection('products');
  Utils utils;
  int count = 30;

  @override
  Widget build(BuildContext context) {
    utils = context.watch<Utils>();
    return Scaffold(
      appBar: utils.appbar('All Products'),
      body: utils.container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(9),
              child: TextField(
                onEditingComplete: () => handleState(),
                onChanged: (value) => text = value,
                style: utils.inputTextStyle(),
                maxLines: 1,
                decoration: getDecoration(),
              ),
            ),
            allProducts()
          ],
        ),
      ),
    );
  }

  /* finterProducts() {
    return DataStreamBuilder<DocumentSnapshot>(
      errorBuilder: (context, error) => utils.nullWidget(error),
      loadingBuilder: (context) => utils.progressIndicator(),
      stream: products.document(queryConroller.text).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return utils.nullWidget('No Products Found !');
        } else {
          return utils.productCard(
            title: snapshot.data['title'],
            description: snapshot.data['description'],
            imageUrl: snapshot.data['images'][0],
            onTap: () {
              FocusScope.of(context).unfocus();
              Get.to(ProductDetails(), arguments: snapshot.documentID);
            },
          );
        }
      },
    );
  } */

  allProducts() {
    return Expanded(
      child: DataStreamBuilder<QuerySnapshot>(
        errorBuilder: (context, error) => utils.nullWidget(error),
        loadingBuilder: (context) => utils.progressIndicator(),
        stream: products
            .where(FieldPath.documentId, isEqualTo: text)
            .limit(count)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.documents.length == 0) {
            return utils.nullWidget('No products found !');
          } else {
            return LazyLoadScrollView(
              onEndOfPage: () {
                count += 30;
                handleState();
              },
              child: ListView.builder(
                itemCount: snapshot.documents.length,
                itemBuilder: (context, index) {
                  try {
                    return utils.productCard(
                      title: snapshot.documents[index].data['title'],
                      description:
                          snapshot.documents[index].data['description'],
                      imageUrl: snapshot.documents[index].data['images'][0],
                      onTap: () => Get.to(
                        ProductDetails(),
                        arguments: snapshot.documents[index].documentID,
                      ),
                    );
                  } catch (e) {
                    return utils.errorListTile();
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  getDecoration() {
    return InputDecoration(
      isDense: true,
      hintText: 'search by Document ID',
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (text != null)
            IconButton(
              icon: Icon(MdiIcons.closeOutline),
              onPressed: () {
                text = null;
                handleState();
              },
            )
        ],
      ),
      contentPadding: EdgeInsets.all(9),
      border: InputBorder.none,
      fillColor: Colors.grey.shade100,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
