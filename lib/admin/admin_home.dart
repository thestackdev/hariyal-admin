import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/all_products.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/services/orders.dart';
import 'package:superuser/services/sold_items.dart';
import 'package:superuser/utils.dart';
import 'admin_extras.dart';

class AdminHome extends StatelessWidget {
  final Utils utils = Utils();
  final products = Firestore.instance.collection('products');
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screenList = [
      Orders(),
      SoldItems(
        query: products
            .where('author', isEqualTo: controllers.firebaseUser.value.uid)
            .where('isSold', isEqualTo: true),
      ),
      PushData(),
      AllProducts(
        query: products.where('author',
            isEqualTo: controllers.firebaseUser.value.uid),
      ),
      AdminExtras(),
    ];
    final items = [
      bottomNavigationBar('Orders', MdiIcons.humanGreeting),
      bottomNavigationBar('Sold Items', MdiIcons.humanMaleMale),
      bottomNavigationBar('Add Items', MdiIcons.plusCircleOutline),
      bottomNavigationBar('Products', MdiIcons.cashUsdOutline),
      bottomNavigationBar('Extras', MdiIcons.receipt),
    ];
    return Obx(
      () => Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => controllers.changeScreen(index),
          currentIndex: controllers.currentScreen.value,
          elevation: 9,
          type: BottomNavigationBarType.fixed,
          items: items,
        ),
        body: WillPopScope(
          child: screenList[controllers.currentScreen.value],
          onWillPop: () async {
            if (controllers.currentScreen.value == 0) {
              return true;
            } else {
              controllers.changeScreen(0);
              return false;
            }
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationBar(String title, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
    );
  }
}
