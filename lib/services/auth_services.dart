import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
                    return Authenticate();
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
          return Authenticate();
        }
      },
    );
  }

  Future addAdmin(email, password, name, context) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _db.collection('admin').document(result.user.uid).setData(
        {
          'since': DateTime.now().millisecondsSinceEpoch,
          'name': name,
          'isSuperuser': false,
          'isAdmin': true,
        },
      );
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);
      _auth.signOut();
      return true;
    } catch (e) {
      return e.toString();
    }
  }

  logout() {
    _auth.signOut();
  }
}
