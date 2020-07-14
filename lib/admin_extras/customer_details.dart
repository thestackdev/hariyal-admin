import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class Customerdetails extends StatefulWidget {
  final DocumentSnapshot docsnap;

  Customerdetails({Key key, this.docsnap}) : super(key: key);

  @override
  _CustomerdetailsState createState() => _CustomerdetailsState();
}

class _CustomerdetailsState extends State<Customerdetails> {
  Utils utils = new Utils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['name'],
              readOnly: true,
              maxLines: null,
              decoration: utils.getDecoration(label: 'Name', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['phoneNumber'],
              readOnly: true,
              maxLines: null,
              decoration: utils.getDecoration(label: 'Phone', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['email'],
              readOnly: true,
              maxLines: null,
              decoration: utils.getDecoration(label: 'Email', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['gender'],
              readOnly: true,
              maxLines: null,
              decoration: utils.getDecoration(label: 'Gender', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['alternatePhoneNumber'],
              readOnly: true,
              maxLines: null,
              decoration:
                  utils.getDecoration(label: 'Alternate Phone', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['permanentAddress'],
              readOnly: true,
              maxLines: null,
              decoration: utils.getDecoration(
                  label: 'Permanent Address', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['location']['cityDistrict'],
              readOnly: true,
              maxLines: null,
              decoration:
                  utils.getDecoration(label: 'City/District', iconData: null),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(9),
            child: TextFormField(
              initialValue: widget.docsnap['location']['state'],
              readOnly: true,
              maxLines: null,
              decoration: utils.getDecoration(label: 'State', iconData: null),
            ),
          ),
        ],
      ),
    );
  }
}
