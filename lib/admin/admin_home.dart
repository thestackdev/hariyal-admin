import 'package:flutter/material.dart';
import 'package:superuser/services/push_data.dart';

import 'admin_extras.dart';
import 'admin_view_data.dart';

class AdminHome extends StatefulWidget {
  final uid;

  const AdminHome({Key key, this.uid}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Admin Console',
            style: TextStyle(fontSize: 25),
          ),
          elevation: 0,
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Insert Data',
              ),
              Tab(
                text: 'View Data',
              ),
              Tab(
                text: 'Extras',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PushData(
              uid: widget.uid,
            ),
            AdminViewData(
              uid: widget.uid,
            ),
            AdminExtras()
          ],
        ),
      ),
    );
  }
}
