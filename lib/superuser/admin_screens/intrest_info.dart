import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:superuser/utils.dart';
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
  Utils utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.getAppbar('Details'),
      body: utils.getContainer(
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(9),
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                child: ImageSliderWidget(
                  dotPosition: 20,
                  onTap: () {
                    /* Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) =>
                            FullScreenView(widget.productsnap['images']),
                      ),
                    ); */
                  },
                  imageHeight: MediaQuery.of(context).size.height / 1.5,
                  tag: widget.productsnap.documentID,
                  imageUrls: widget.productsnap.data['images'],
                  fit: BoxFit.contain,
                )),
            Container(
              child: ListTile(
                title: Text(
                  '${widget.productsnap.data['title']}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
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
            ...ListTile.divideTiles(color: Colors.grey, tiles: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Icon(Icons.person_outline),
                  title: Text("Name"),
                  subtitle: Text(
                    widget.usersnap.data['name'] == null
                        ? '-'
                        : widget.usersnap.data['name'],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Icon(Icons.email),
                  title: Text("E-mail"),
                  subtitle: Text(
                    widget.usersnap.data['email'] == null
                        ? '-'
                        : widget.usersnap.data['email'],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: Icon(Icons.phone),
                  title: Text("Phone"),
                  subtitle: Text(
                    widget.usersnap.data['phone'] == null
                        ? '-'
                        : widget.usersnap.data['phone'],
                  ),
                ),
              ),
            ]),
            SizedBox(),
          ],
        ),
      ),
    );
  }
}
