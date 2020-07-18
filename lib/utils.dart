import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Utils {
  textStyle({Color color, double fontSize}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      letterSpacing: 1.0,
      color: color,
    );
  }

  getDecoration({label, iconData}) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      labelStyle: textStyle(),
      contentPadding: EdgeInsets.all(16),
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

  getSnackbar(GlobalKey<ScaffoldState> key, message) {
    key.currentState.removeCurrentSnackBar();
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(message, style: textStyle()),
        backgroundColor: Colors.red.shade300,
        duration: Duration(seconds: 1),
      ),
    );
  }

  getContainer({Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white.withOpacity(0.99),
        ),
        child: child,
      ),
    );
  }

  Widget getAppbar(label,
      {Widget boottom, Widget leading, List<Widget> actions}) {
    return AppBar(
      leading: leading,
      actions: actions,
      title: Text(
        label,
        style: textStyle(fontSize: 23),
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
        style: textStyle(color: Colors.grey),
        textScaleFactor: 1.5,
        textAlign: TextAlign.center,
      ),
    );
  }

  getLoadingIndicator() {
    return Center(
      child: SpinKitRing(color: Colors.red.shade300, lineWidth: 5),
    );
  }

  Widget getRaisedButton({onPressed, title}) {
    return Center(
      child: RaisedButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        color: Colors.red.shade300,
        child: Text(
          title,
          style: textStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget getTextInputPadding({child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 27, vertical: 9),
      child: child,
    );
  }

  Widget alertDialog(
      {String content, Function yesPressed, Function noPressed}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text('Are you sure', style: textStyle(color: Colors.red)),
      content: Text(content, style: textStyle(color: Colors.grey)),
      actions: [
        FlatButton(
            child: Text('Yes', style: textStyle()), onPressed: yesPressed),
        FlatButton(child: Text('No', style: textStyle()), onPressed: noPressed),
      ],
    );
  }

  Widget listTile({String title,
    Function onTap,
    Widget leading,
    bool isTrailingNull = false}) {
    return Container(
      margin: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.shade100,
      ),
      child: ListTile(
        leading: leading,
        trailing: isTrailingNull
            ? SizedBox.shrink()
            : Icon(
          MdiIcons.chevronRight,
          color: Colors.red,
        ),
        onTap: onTap,
        title: Text(title, style: TextStyle(color: Colors.grey.shade700)),
      ),
    );
  }
}
