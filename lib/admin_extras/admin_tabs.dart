import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:superuser/superuser/product_details.dart';

class AdminExtras extends StatefulWidget {
  final uid;

  const AdminExtras({Key key, this.uid}) : super(key: key);
  @override
  _AdminExtrasState createState() => _AdminExtrasState();
}

class _AdminExtrasState extends State<AdminExtras> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Extras'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Products',
              ),
              Tab(
                text: 'Privileges',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            getProducts(),
            getPrivilages(),
          ],
        ),
      ),
    );
  }

  getProducts() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('admin')
          .document(widget.uid)
          .collection('products')
          .orderBy('dateTime', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(12),
                elevation: 4,
                shadowColor: Colors.deepPurple,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: StreamBuilder<DocumentSnapshot>(
                      stream: Firestore.instance
                          .collection('products')
                          .document(snapshot.data.documents[index].documentID)
                          .snapshots(),
                      builder: (context, productSnap) {
                        if (productSnap.hasData) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ProductDetails(
                                    productSnap.data,
                                    widget.uid,
                                  ),
                                ),
                              );
                            },
                            leading: Image.network(
                              productSnap.data['images'][0],
                              height: 90,
                              width: 90,
                            ),
                            title: Text('${productSnap.data['title']}'),
                            subtitle:
                                Text('${productSnap.data['description']}'),
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ),
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  getPrivilages() {
    return StreamBuilder<DocumentSnapshot>(
      stream: Firestore.instance
          .collection('admin')
          .document(widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.grey.shade300),
                child: SwitchListTile(
                  title: Text('Admin'),
                  onChanged: (bool value) {
                    snapshot.data.reference.updateData({
                      'isAdmin': !snapshot.data['isAdmin'],
                    });
                  },
                  value: snapshot.data['isAdmin'],
                ),
              ),
              Container(
                margin: EdgeInsets.all(9),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: Colors.grey.shade300),
                child: SwitchListTile(
                  title: Text('Superuser'),
                  onChanged: (bool value) {
                    snapshot.data.reference.updateData({
                      'isSuperuser': !snapshot.data['isSuperuser'],
                    });
                  },
                  value: snapshot.data['isSuperuser'],
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
