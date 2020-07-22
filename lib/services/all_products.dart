import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/superuser/product_details.dart';
import 'package:superuser/utils.dart';

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  bool isSearchActive = false;
  final queryConroller = TextEditingController();
  bool isQueryActive = false;
  Firestore firestore = Firestore.instance;
  Utils utils = Utils();
  int count = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('All Products'),
      body: utils.container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.red,
              padding: const EdgeInsets.all(9),
              child: TextField(
                style: TextStyle(color: Colors.grey, fontSize: 16),
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetails(
                    docID: snapshot.data.documentID,
                  ),
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
      child: StreamBuilder(
        stream: firestore.collection('products').limit(count).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents.length == 0) {
              return utils.nullWidget('No products found !');
            } else {
              return LazyLoadScrollView(
                onEndOfPage: () {
                  count += 30;
                  handleState();
                },
                child: ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      return StreamBuilder<DocumentSnapshot>(
                        stream: firestore
                            .collection('products')
                            .document(snapshot.data.documents[index].documentID)
                            .snapshots(),
                        builder: (context, productSnap) {
                          if (productSnap.hasData) {
                            return utils.productCard(
                              title: productSnap.data['title'],
                              description: productSnap.data['description'],
                              imageUrl: productSnap.data['images'][0],
                              onTap: () => Get.to(
                                ProductDetails(
                                  docID:
                                      snapshot.data.documents[index].documentID,
                                ),
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      );
                    } catch (e) {
                      return utils.errorListTile();
                    }
                  },
                ),
              );
            }
          } else {
            return utils.progressIndicator();
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
