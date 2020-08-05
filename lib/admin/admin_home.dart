import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/admin/pending.dart';
import 'package:superuser/admin/rejected.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/orders.dart';
import 'package:superuser/services/sold_items.dart';
import 'admin_extras.dart';

class AdminHome extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screenList = [
      Orders(),
      Pending(),
      Rejected(),
      SoldItems(
        query: controllers.products
            .where('author', isEqualTo: controllers.firebaseUser.value.uid)
            .where('isSold', isEqualTo: true),
      ),
      AdminExtras(),
    ];
    final items = [
      bottomNavigationBar('Orders', OMIcons.addShoppingCart),
      bottomNavigationBar('Pending', OMIcons.addShoppingCart),
      bottomNavigationBar('Rejected', OMIcons.exitToApp),
      bottomNavigationBar('Sold Items', OMIcons.attachMoney),
      bottomNavigationBar('Extras', OMIcons.more),
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
