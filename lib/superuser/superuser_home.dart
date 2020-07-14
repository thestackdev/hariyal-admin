import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superuser/services/auth_services.dart';
import 'package:superuser/services/push_data.dart';
import 'admin_screens/admins.dart';
import 'admin_screens/all_customers.dart';
import 'admin_screens/extras.dart';
import 'admin_screens/reports.dart';
import 'admin_screens/requests.dart';
import 'admin_screens/sold_items.dart';
import 'admin_screens/user_intrests.dart';

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
    'PushData',
    'SoldItems',
    'Reports',
    'UserIntrests',
    'AllCustomers',
    'Admins',
    'Extras'
  ];

  @override
  void initState() {
    screenList = [
      Requests(),
      PushData(
        uid: widget.uid,
      ),
      SoldItems(),
      Reports(),
      UserIntrests(),
      AllCustomers(),
      Admins(),
      Extras(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titleList[currentScreen],
          style: TextStyle(
              letterSpacing: 1.0, fontSize: 23, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: 225,
          child: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 70,
                  child: Text('//TODO Logo'),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 0;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[0])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 1;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[1])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 2;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[2])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 3;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[3])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 4;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[4])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 5;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[5])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 6;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[6])),
                ),
                ListTile(
                  onTap: () {
                    setState(() {
                      currentScreen = 7;
                    });
                    Navigator.pop(context);
                  },
                  title: Center(child: Text(titleList[7])),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future:
            Firestore.instance.collection('admin').document(widget.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['super_user'] == false) {
              AuthServices().logout();
              Fluttertoast.showToast(msg: 'Insufficient Privilages');
              return Container();
            } else {
              return screenList[currentScreen];
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
