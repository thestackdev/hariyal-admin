import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:superuser/admin/admin_home.dart';
import 'package:superuser/superuser/authenticate.dart';
import 'package:superuser/superuser/superuser_home.dart';

class AuthServices {
  Firestore _db = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder<FirebaseUser>(
      stream: _auth.onAuthStateChanged,
      builder: (_, authsnap) {
        if (authsnap.hasData) {
          return StreamBuilder<DocumentSnapshot>(
              stream: _db
                  .collection('admin')
                  .document(authsnap.data.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data['isSuperuser']) {
                    return SuperuserHome(
                      uid: authsnap.data.uid,
                    );
                  } else if (snapshot.data['isAdmin']) {
                    return AdminHome(
                      uid: authsnap.data.uid,
                    );
                  } else {
                    logout();
                    return AdminAuthenticate();
                  }
                } else {
                  return Container(
                    color: Colors.white,
                    child: Center(
                      child: SpinKitRing(
                        color: Colors.red.shade300,
                        lineWidth: 5,
                      ),
                    ),
                  );
                }
              });
        } else {
          return AdminAuthenticate();
        }
      },
    );
  }

  superuserLogin(email, password) async {
    Fluttertoast.showToast(msg: 'Authenticating...');
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return false;
    }
  }

  logout() {
    _auth.signOut();
  }
}
