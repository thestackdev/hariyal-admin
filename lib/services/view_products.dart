import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
  final queryConroller = TextEditingController();
  bool isQueryActive = false;
  Firestore firestore = Firestore.instance;
  Utils utils;
  int count = 30;

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
                return utils.card(
                  title: snapshot.documents[index].data['title'],
                  description: snapshot.documents[index].data['description'],
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
          );
        }
      },
    );
  }

  finterProducts() {
    return DataStreamBuilder<DocumentSnapshot>(
      errorBuilder: (context, error) => utils.nullWidget(error),
      loadingBuilder: (context) => utils.progressIndicator(),
      stream: firestore
          .collection('products')
          .document(queryConroller.text)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null || !snapshot.data['isSold']) {
          return utils.nullWidget('No Products Found !');
        } else {
          return utils.card(
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
