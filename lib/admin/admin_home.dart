import 'package:flutter/material.dart';
import 'package:superuser/services/push_data.dart';
import 'package:superuser/services/view_products.dart';
import 'package:superuser/utils.dart';

import 'admin_extras.dart';

class AdminHome extends StatefulWidget {
  final uid;

  const AdminHome({Key key, this.uid}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  Utils utils = Utils();

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.getAppbar(
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
            tabController.animateTo(0);
            handleState();
            return false;
          }
        },
        child: TabBarView(
          controller: tabController,
          children: [
            PushData(
              uid: widget.uid,
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: utils.getBoxDecoration(),
              child: getViewProducts(widget.uid),
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
