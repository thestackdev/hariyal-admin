import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

class SoldItems extends StatelessWidget {
  final CollectionReference soldItems =
      Firestore.instance.collection('products');
  final Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return utils.container(
      child: ViewMyProducts(
        stream: soldItems.where('isSold', isEqualTo: true).snapshots(),
      ),
    );
  }
}
