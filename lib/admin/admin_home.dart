import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/admin/pending.dart';
import 'package:superuser/admin/rejected.dart';
import 'package:superuser/services/orders.dart';
import 'admin_extras.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  PageController pageController;
  int currentIndex = 0;

  final items = [
    BottomNavyBarItem(
      icon: Icon(OMIcons.shoppingBasket),
      title: Text('Orders'),
      activeColor: Colors.purpleAccent,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.add_shopping_cart),
      title: Text('Pending'),
      activeColor: Colors.pink,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(OMIcons.closedCaption),
      title: Text('Rejected'),
      activeColor: Colors.red,
      textAlign: TextAlign.center,
    ),
    BottomNavyBarItem(
      icon: Icon(Icons.more_horiz),
      title: Text('More'),
      activeColor: Colors.red,
      textAlign: TextAlign.center,
    ),
  ];

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (value) => setState(() {
          currentIndex = value;
          pageController.jumpToPage(value);
        }),
        items: items,
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (currentIndex == 0) {
            return true;
          } else {
            setState(() {
              currentIndex = 0;
              pageController.jumpToPage(0);
            });
            return false;
          }
        },
        child: PageView(
          controller: pageController,
          onPageChanged: (value) => setState(() => currentIndex = value),
          children: [Orders(), Pending(), Rejected(), AdminExtras()],
        ),
      ),
    );
  }
}
