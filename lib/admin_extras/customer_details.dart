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
      appBar: utils.getAppbar('Customer Details'),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: utils.getBoxDecoration(),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['name'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Name'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['phone'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Phone'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['email'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['gender'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Gender'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['alternatePhoneNumber'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Alternate Phone'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['permanentAddress'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Permanent Address'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['location']['cityDistrict'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'City/District'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextFormField(
                initialValue: widget.docsnap['location']['state'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'State'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
