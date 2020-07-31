import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/utils.dart';

import '../services/orders.dart';
import '../services/sold_items.dart';
import 'superuser_screens/reports.dart';
import 'superuser_screens/requests.dart';

class SuperuserHome extends StatelessWidget {
  final controllers = Controllers.to;
  final utils = Utils();
  final soldItems = Firestore.instance
      .collection('products')
      .where('isSold', isEqualTo: true);

  @override
  Widget build(BuildContext context) {
    final items = [
      bottomNavigationBar('Orders', MdiIcons.humanGreeting),
      bottomNavigationBar('Requests', MdiIcons.humanMaleMale),
      bottomNavigationBar('Add Items', MdiIcons.plusCircleOutline),
      bottomNavigationBar('Sold Items', MdiIcons.cashUsdOutline),
      bottomNavigationBar('Reports', MdiIcons.receipt),
    ];
    final screenList = [
      Orders(),
      Requests(),
      PushData(),
      SoldItems(query: soldItems),
      Reports(),
    ];
    return Obx(() {
      return Scaffold(
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
      );
    });
  }

  BottomNavigationBarItem bottomNavigationBar(String title, IconData icon) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
    );
  }
}
