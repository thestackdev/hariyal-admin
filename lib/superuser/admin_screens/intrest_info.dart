import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/widgets/image_slider.dart';

class IntrestInfo extends StatefulWidget {
  final DocumentSnapshot usersnap;
  final DocumentSnapshot productsnap;

  const IntrestInfo({Key key, this.usersnap, this.productsnap})
      : super(key: key);

  @override
  _InterestInfoState createState() => _InterestInfoState();
}

class _InterestInfoState extends State<IntrestInfo> {
  @override
  void initState() {
    initGetData();
    super.initState();
  }

  Future initGetData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(12),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height / 2,
                    width: MediaQuery.of(context).size.width,
                    child: ImageSliderWidget(
                      dotPosition: 20,
                      onTap: () {
                        /*Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 500),
                          pageBuilder: (_, __, ___) => FullScreenView(
                              productModel.images, productModel.id)));*/
                      },
                      imageHeight: MediaQuery.of(context).size.height / 1.5,
                      tag: widget.productsnap.documentID,
                      imageUrls: widget.productsnap.data['images'],
                      fit: BoxFit.contain,
                    )),
                Container(
                  padding: EdgeInsets.all(6),
                  child: Expanded(
                    child: ListTile(
                      title: Text(
                        '${widget.productsnap.data['title']}',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                            '${widget.productsnap.data['price']} Rs',
                            style: TextStyle(fontSize: 18),
                          ),
                          Spacer(),
                          Text(
                            '${widget.productsnap.documentID}',
                            textScaleFactor: 1.2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 12),
                  alignment: FractionalOffset.topLeft,
                  child: Text(
                    'User Information',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Column(
                  children: <Widget>[
                    ...ListTile.divideTiles(color: Colors.grey, tiles: [
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Icon(Icons.person),
                        title: Text("Name"),
                        subtitle: Text(widget.usersnap.data['name']),
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Icon(Icons.email),
                        title: Text("E-mail"),
                        subtitle: Text(widget.usersnap.data['email']),
                      ),
                      ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        leading: Icon(Icons.phone),
                        title: Text("Phone"),
                        subtitle: Text(widget.usersnap.data['phoneNumber']),
                      ),
                    ])
                  ],
                ),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
