import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/superuser/admin_screens/settings.dart';

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
      PushData(
        uid: widget.uid,
      ),
      Reports(),
      Extras(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
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
        title: Text(
          titleList[currentScreen],
          style: TextStyle(
            letterSpacing: 1.0,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
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
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.humanGreeting),
            icon: Icon(MdiIcons.humanGreeting),
            title: Text('Requests'),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.cashUsdOutline),
            icon: Icon(MdiIcons.cashUsdOutline),
            title: Text('Sold Items'),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.plusCircleOutline),
            icon: Icon(MdiIcons.plusCircleOutline),
            title: Text('Add Items'),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.receipt),
            icon: Icon(MdiIcons.receipt),
            title: Text('Reports'),
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(MdiIcons.more),
            icon: Icon(MdiIcons.more),
            title: Text('Extras'),
          ),
        ],
      ),
      body: WillPopScope(
        child: screenList[currentScreen],
        onWillPop: () async {
          if (currentScreen == 0) {
            return await showDialog(
              context: context,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                title: Text(
                  'Are you sure ?',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Text(
                  'Do you want to exiti',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        return true;
                      }),
                  FlatButton(
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      return false;
                    },
                  ),
                ],
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

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
