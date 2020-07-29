import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/utils.dart';
import 'superuser_screens/orders.dart';
import 'superuser_screens/reports.dart';
import 'superuser_screens/requests.dart';
import 'superuser_screens/sold_items.dart';

class SuperuserHome extends StatelessWidget {
  final Controllers controllers = Controllers.to;
  final Utils utils = Utils();
  final List<Widget> screenList = [
    Orders(),
    Requests(),
    PushData(),
    SoldItems(),
    Reports(),
  ];
  final titleList = [
    'Orders',
    'Requests',
    'Add Items',
    'Sold Items',
    'Reports',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: utils.appbar(
          titleList[controllers.currentScreen.value],
          leading: Visibility(
            visible: controllers.currentScreen.value == 0 ? false : true,
            child: IconButton(
              icon: Icon(MdiIcons.arrowLeft),
              onPressed: () => controllers.changeScreen(0),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () => Get.toNamed('/settings'),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => controllers.changeScreen(index),
          currentIndex: controllers.currentScreen.value,
          elevation: 9,
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationBar(titleList[0], MdiIcons.humanGreeting),
            bottomNavigationBar(titleList[1], MdiIcons.humanMaleMale),
            bottomNavigationBar(titleList[2], MdiIcons.plusCircleOutline),
            bottomNavigationBar(titleList[3], MdiIcons.cashUsdOutline),
            bottomNavigationBar(titleList[4], MdiIcons.receipt),
          ],
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
