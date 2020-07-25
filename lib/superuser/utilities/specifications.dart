import 'package:flutter/material.dart';

class Specifications extends StatefulWidget {
  final mapKey;

  const Specifications({Key key, this.mapKey}) : super(key: key);

  @override
  _SpecificationsState createState() => _SpecificationsState();
}

class _SpecificationsState extends State<Specifications> {
  @override
  Widget build(BuildContext context) {
    print(widget.mapKey);
    return Container();
  }
}
