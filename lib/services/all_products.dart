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
  bool isSearchActive = false;
  final queryConroller = TextEditingController();
  bool isQueryActive = false;
  Firestore firestore = Firestore.instance;
  Utils utils;
  int count = 30;

  @override
  void dispose() {
    queryConroller.dispose();
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
              padding: const EdgeInsets.all(9),
              child: TextField(
                style: utils.inputTextStyle(),
                maxLines: null,
                controller: queryConroller,
                decoration: getDecoration(),
              ),
            ),
            isQueryActive ? finterProducts() : allProducts()
          ],
        ),
      ),
    );
  }

  finterProducts() {
    return DataStreamBuilder(
      errorBuilder: (context, error) => utils.nullWidget(error),
      loadingBuilder: (context) => utils.progressIndicator(),
      stream: firestore
          .collection('products')
          .document(queryConroller.text)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data.data == null) {
          return utils.nullWidget('No Products Found !');
        } else {
          return utils.productCard(
            title: snapshot.data['title'],
            description: snapshot.data['description'],
            imageUrl: snapshot.data['images'][0],
            onTap: () {
              FocusScope.of(context).unfocus();
              Get.to(
                ProductDetails(
                  docID: snapshot.data.documentID,
                ),
              );
            },
          );
        }
      },
    );
  }

  allProducts() {
    return Expanded(
      child: DataStreamBuilder<QuerySnapshot>(
        errorBuilder: (context, error) => utils.nullWidget(error),
        loadingBuilder: (context) => utils.progressIndicator(),
        stream: firestore.collection('products').limit(count).snapshots(),
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
                        ProductDetails(
                          docID: snapshot.documents[index].documentID,
                        ),
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
          IconButton(
            icon: Icon(MdiIcons.shoppingSearch),
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (queryConroller.text.length > 0) {
                isQueryActive = true;
                FocusScope.of(context).unfocus();
                handleState();
              }
            },
          ),
          isQueryActive
              ? IconButton(
                  icon: Icon(MdiIcons.closeOutline),
                  onPressed: () {
                    if (isQueryActive) {
                      queryConroller.clear();
                      isQueryActive = false;
                      handleState();
                    }
                  },
                )
              : SizedBox()
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
