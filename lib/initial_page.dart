import 'package:flutter/material.dart';

class InitialRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          image: AssetImage('assets/hariyal.png'),
        ),
      ),
      child: Center(),
    );
  }
}
