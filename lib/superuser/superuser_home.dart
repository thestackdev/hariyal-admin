import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/utils.dart';

import 'superuser_screens/more.dart';
import 'superuser_screens/orders.dart';
import 'superuser_screens/reports.dart';
import 'superuser_screens/requests.dart';
import 'superuser_screens/sold_items.dart';

class SuperuserHome extends StatelessWidget {
  final Controllers controllers = Get.put(Controllers());
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
    'Reports'
  ];

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return Obx(
      () => Scaffold(
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
                onPressed: () => Get.to(Settings())),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => controllers.changeScreen(index),
          currentIndex: controllers.currentScreen.value,
          elevation: 18,
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationBar(
              title: titleList[0],
              icon: MdiIcons.humanGreeting,
            ),
            bottomNavigationBar(
              title: titleList[1],
              icon: MdiIcons.receipt,
            ),
            bottomNavigationBar(
              title: titleList[2],
              icon: MdiIcons.plusCircleOutline,
            ),
            bottomNavigationBar(
              title: titleList[3],
              icon: MdiIcons.cashUsdOutline,
            ),
            bottomNavigationBar(title: titleList[4], icon: MdiIcons.receipt),
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
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationBar({String title, IconData icon}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
    );
  }
}
