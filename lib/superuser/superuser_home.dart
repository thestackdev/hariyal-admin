import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/utils.dart';

import 'superuser_screens/more.dart';
import 'superuser_screens/reports.dart';
import 'superuser_screens/requests.dart';
import 'superuser_screens/sold_items.dart';

class SuperuserHome extends StatefulWidget {
  @override
  _SuperuserHomeState createState() => _SuperuserHomeState();
}

class _SuperuserHomeState extends State<SuperuserHome> {
  int currentScreen = 0;
  final screenList = [Requests(), SoldItems(), PushData(), Reports()];
  final titleList = ['Orders', 'Sold Items', 'Add Items', 'Reports'];

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
              }),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () => Get.to(Settings())),
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
            title: titleList[0],
            icon: MdiIcons.humanGreeting,
          ),
          bottomNavigationBar(
            title: titleList[1],
            icon: MdiIcons.cashUsdOutline,
          ),
          bottomNavigationBar(
            title: titleList[2],
            icon: MdiIcons.plusCircleOutline,
          ),
          bottomNavigationBar(
            title: titleList[3],
            icon: MdiIcons.receipt,
          ),
        ],
      ),
      body: WillPopScope(
        child: screenList[currentScreen],
        onWillPop: () async {
          if (currentScreen == 0) {
            return true;
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

  handleState() => (mounted) ? setState(() => null) : null;
}
