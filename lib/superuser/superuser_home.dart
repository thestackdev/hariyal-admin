import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/superuser/admin_screens/settings.dart';
import 'package:superuser/utils.dart';

import 'admin_screens/extras.dart';
import 'admin_screens/reports.dart';
import 'admin_screens/requests.dart';
import 'admin_screens/sold_items.dart';

class SuperuserHome extends StatefulWidget {
  @override
  _SuperuserHomeState createState() => _SuperuserHomeState();
}

class _SuperuserHomeState extends State<SuperuserHome> {
  int currentScreen = 0;
  List screenList = [
    Requests(),
    SoldItems(),
    PushData(),
    Reports(),
    Extras(),
  ];
  final titleList = [
    'Requests',
    'Sold Items',
    'Add Items',
    'Reports',
    'Extras',
  ];

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return Scaffold(
      appBar: utils.appbar(
        titleList[currentScreen],
        leading: Visibility(
          visible: currentScreen == 0 ? false : true,
          child: IconButton(
            icon: Icon(MdiIcons.arrowLeft),
            onPressed: () {
              currentScreen = 0;
              handleState();
            },
          ),
        ),
        actions: <Widget>[
          Center(
            child: IconButton(
                icon: Icon(MdiIcons.cogOutline),
                onPressed: () => Get.to(Settings())),
          ),
          SizedBox(width: 9)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          currentScreen = index;
          handleState();
        },
        currentIndex: currentScreen,
        elevation: 18,
        type: BottomNavigationBarType.fixed,
        items: [
          bottomNavigationBar(
            title: 'Orders',
            icon: MdiIcons.humanGreeting,
          ),
          bottomNavigationBar(
            title: 'Sold Items',
            icon: MdiIcons.cashUsdOutline,
          ),
          bottomNavigationBar(
            title: 'Add Items',
            icon: MdiIcons.plusCircleOutline,
          ),
          bottomNavigationBar(
            title: 'Reports',
            icon: MdiIcons.receipt,
          ),
          bottomNavigationBar(
            title: 'Extras',
            icon: MdiIcons.more,
          ),
        ],
      ),
      body: WillPopScope(
        child: screenList[currentScreen],
        onWillPop: () async {
          if (currentScreen == 0) {
            return await showDialog(
              context: context,
              builder: (context) {
                return utils.alertDialog(
                  content: 'Exit ?',
                  yesPressed: () => SystemChannels.platform
                      .invokeMethod('SystemNavigator.pop'),
                  noPressed: () => Navigator.of(context).pop(false),
                );
              },
            );
          } else {
            currentScreen = 0;
            handleState();
            return false;
          }
        },
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationBar({String title, IconData icon}) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      title: Text(title),
    );
  }

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
