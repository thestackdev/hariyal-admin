import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

class SoldItems extends StatefulWidget {
  @override
  _SoldItemsState createState() => _SoldItemsState();
}

class _SoldItemsState extends State<SoldItems> {
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return utils.container(
      child: ViewMyProducts(
        stream: Firestore.instance
            .collection('products')
            .where('isSold', isEqualTo: true)
            .snapshots(),
      ),
    );
  }
}
