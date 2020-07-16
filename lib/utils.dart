import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  getDecoration({label, iconData}) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      labelStyle: TextStyle(
        color: Colors.red.shade300,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.0,
      ),
      contentPadding: EdgeInsets.all(18),
      border: InputBorder.none,
      fillColor: Colors.grey.shade100,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      prefix: iconData != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  iconData,
                  color: Colors.red.shade300,
                  size: 18,
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            )
          : SizedBox(),
    );
  }

  getBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      color: Colors.white.withOpacity(0.99),
    );
  }

  getAppbar(label, {boottom}) {
    return AppBar(
      title: Text(
        label,
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      bottom: boottom,
    );
  }

  getNullWidget(label) {
    return Center(
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        ),
        textScaleFactor: 1.5,
        textAlign: TextAlign.center,
      ),
    );
  }

  getLoadingIndicator() {
    return Center(
      child: SpinKitRing(
        color: Colors.red.shade300,
        lineWidth: 5.0,
      ),
    );
  }

  getToast(message) {
    Fluttertoast.showToast(msg: message);
  }

  getRaisedButton({onPressed, title}) {
    return Center(
      child: RaisedButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        color: Colors.red.shade300,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
