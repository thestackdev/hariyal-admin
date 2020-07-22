import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

import 'admin_extras.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    return Scaffold(
      appBar: utils.appbar(
        'Admin Console',
        boottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(text: 'Insert Data'),
            Tab(text: 'View Data'),
            Tab(text: 'Extras')
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (tabController.index == 0) {
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
                  }),
            );
          } else {
            tabController.animateTo(0);
            handleState();
            return false;
          }
        },
        child: TabBarView(
          controller: tabController,
          children: [PushData(), ViewMyProducts(), AdminExtras()],
        ),
      ),
    );
  }

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
