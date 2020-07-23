import 'package:cloud_firestore/cloud_firestore.dart';
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
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final utils = context.watch<Utils>();
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    return Scaffold(
      appBar: utils.appbar(
        'Admin Console',
        boottom: TabBar(
          labelStyle: textStyle,
          controller: tabController,
          indicatorColor: Colors.transparent,
          tabs: [
            Tab(text: 'Add Data'),
            Tab(text: 'Products'),
            Tab(text: 'Extras')
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (tabController.index == 0) {
            return true;
          } else {
            tabController.animateTo(0);
            handleState();
            return false;
          }
        },
        child: TabBarView(
          controller: tabController,
          children: [
            PushData(),
            utils.container(
              child: ViewMyProducts(
                stream: Firestore.instance
                    .collection('products')
                    .where('author',
                    isEqualTo:
                    Provider
                        .of<DocumentSnapshot>(context)
                        .documentID)
                    .snapshots(),
              ),
            ),
            AdminExtras()
          ],
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
