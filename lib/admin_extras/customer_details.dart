import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:strings/strings.dart';

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
      body: utils.getContainer(
        child: ListView(
          children: <Widget>[
            SizedBox(height: 30),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: capitalize(widget.docsnap['name']),
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Name'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: widget.docsnap['phone'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Phone'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: widget.docsnap['email'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Email'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: capitalize(widget.docsnap['gender']),
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Gender'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: widget.docsnap['alternatePhoneNumber'],
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Alternate Phone'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: capitalize(widget.docsnap['permanentAddress']),
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'Permanent Address'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue:
                    capitalize(widget.docsnap['location']['cityDistrict']),
                readOnly: true,
                maxLines: null,
                decoration: utils.getDecoration(label: 'City/District'),
              ),
            ),
            utils.getTextInputPadding(
              child: TextFormField(
                style: utils.textStyle(color: Colors.grey.shade700),
                initialValue: capitalize(widget.docsnap['location']['state']),
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
