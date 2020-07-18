import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/superuser/admin_screens/settings.dart';
import 'package:superuser/utils.dart';

import 'admin_screens/extras.dart';
import 'admin_screens/reports.dart';
import 'admin_screens/requests.dart';
import 'admin_screens/sold_items.dart';

class SuperuserHome extends StatefulWidget {
  final uid;

  const SuperuserHome({Key key, this.uid}) : super(key: key);

  @override
  _SuperuserHomeState createState() => _SuperuserHomeState();
}

class _SuperuserHomeState extends State<SuperuserHome> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  Utils utils = Utils();
  String uid;
  int currentScreen = 0;
  List screenList = [];
  final titleList = [
    'Requests',
    'Sold Items',
    'Add Items',
    'Reports',
    'Extras',
  ];

  @override
  void initState() {
    screenList = [
      Requests(),
      SoldItems(),
      PushData(uid: widget.uid, scaffoldkey: scaffoldKey),
      Reports(),
      Extras(uid: widget.uid),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: utils.getAppbar(
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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Settings(),
                ),
              ),
            ),
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
              child: utils.alertDialog(
                content: 'Exit ?',
                yesPressed: () {
                  Navigator.pop(context);
                  return true;
                },
                noPressed: () {
                  Navigator.pop(context);
                  return false;
                },
              ),
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
