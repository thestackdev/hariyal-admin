import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

class SoldItems extends StatefulWidget {
  @override
  _SoldItemsState createState() => _SoldItemsState();
}

class _SoldItemsState extends State<SoldItems> {
  Firestore firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return utils.container(
      child: ViewMyProducts(
        stream: firestore
            .collection('products')
            .where('isSold', isEqualTo: true)
            .snapshots(),
      ),
    );
  }
}
