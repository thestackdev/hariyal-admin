import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:superuser/admin/admin_home.dart';
import 'package:superuser/superuser/authenticate.dart';
import 'package:superuser/superuser/superuser_home.dart';
import 'package:superuser/utils.dart';

final Utils utils = Utils();
final Firestore firestore = Firestore.instance;
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  Widget homeWidget() {
    firebaseAuth.signOut();
    return Authenticate();
  }

  runApp(
    Phoenix(
      child: StreamBuilder<FirebaseUser>(
        initialData: null,
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: utils.progressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return DataStreamBuilder<DocumentSnapshot>(
                loadingBuilder: (context) => Container(
                      color: Colors.white,
                      child: utils.progressIndicator(),
                    ),
                stream: Firestore.instance
                    .collection('admin')
                    .document(snapshot.data.uid)
                    .snapshots(),
                builder: (context, adminsnap) {
                  return MultiProvider(
                    providers: [
                      StreamProvider<QuerySnapshot>.value(
                        initialData: null,
                        value: firestore.collection('extras').snapshots(),
                      ),
                      Provider<DocumentSnapshot>.value(
                        value: adminsnap,
                      ),
                      Provider<Utils>.value(
                        value: utils,
                      ),
                    ],
                    child: GetMaterialApp(
                      defaultTransition: Transition.rightToLeftWithFade,
                      enableLog: false,
                      theme: ThemeData(
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        fontFamily: 'Ubuntu',
                        primarySwatch: Colors.red,
                        scaffoldBackgroundColor: Colors.red,
                      ),
                      debugShowCheckedModeBanner: false,
                      home: adminsnap.data['isSuperuser']
                          ? SuperuserHome()
                          : adminsnap.data['isAdmin']
                              ? AdminHome()
                              : homeWidget(),
                    ),
                  );
                });
          } else {
            return GetMaterialApp(
              defaultTransition: Transition.rightToLeftWithFade,
              enableLog: false,
              theme: ThemeData(
                visualDensity: VisualDensity.adaptivePlatformDensity,
                fontFamily: 'Ubuntu',
                primarySwatch: Colors.red,
                scaffoldBackgroundColor: Colors.red,
              ),
              debugShowCheckedModeBanner: false,
              home: Authenticate(),
            );
          }
        },
      ),
    ),
  );
}
