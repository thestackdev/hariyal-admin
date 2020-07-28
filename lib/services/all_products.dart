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
  TextEditingController controller = TextEditingController();
  final CollectionReference products =
      Firestore.instance.collection('products');
  Utils utils;
  int count = 30;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
                controller: controller,
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

  allProducts() {
    return Expanded(
      child: DataStreamBuilder<QuerySnapshot>(
        errorBuilder: (context, error) => utils.nullWidget(error),
        loadingBuilder: (context) => utils.progressIndicator(),
        stream: controller.text.length > 0
            ? products
                .where(FieldPath.documentId, isEqualTo: controller.text)
                .limit(count)
                .snapshots()
            : products.limit(count).snapshots(),
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
      hintText: 'Search by Document ID',
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (controller.text.length > 0)
            IconButton(
              icon: Icon(MdiIcons.closeOutline),
              onPressed: () {
                controller.clear();
                FocusScope.of(context).unfocus();
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
