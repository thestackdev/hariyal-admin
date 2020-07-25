import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:strings/strings.dart';

class Utils {
  textStyle({Color color, double fontSize}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      letterSpacing: 1.0,
      color: color,
    );
  }

  blankScreenLoading() {
    return Container(
      color: Colors.white,
      child: progressIndicator(),
    );
  }

  dismissible({
    Key key,
    Widget child,
    Future<bool> Function(DismissDirection) confirmDismiss,
  }) {
    return Dismissible(
      key: key,
      child: child,
      confirmDismiss: confirmDismiss,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.red,
        ),
        child: ListTile(
          leading: Icon(
            MdiIcons.deleteOffOutline,
            color: Colors.white,
          ),
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.blue,
        ),
        child: ListTile(
          trailing: Icon(
            MdiIcons.pencilOutline,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  getSimpleDialouge({
    String title,
    Function yesPressed,
    Function noPressed,
    Widget content,
  }) {
    return Get.dialog(
      AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Center(
          child: Text(
            title,
            style: textStyle(
              color: Colors.red,
            ),
          ),
        ),
        content: content,
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel', style: textStyle()),
            onPressed: noPressed,
          ),
          FlatButton(
            child: Text('Confirm', style: textStyle()),
            onPressed: yesPressed,
          ),
        ],
      ),
    );
  }

  dialogInput({String hintText, TextEditingController controller}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: inputTextStyle(),
        isDense: true,
        labelStyle: textStyle(color: Colors.red),
        contentPadding: EdgeInsets.all(12),
        border: InputBorder.none,
        fillColor: Colors.grey.shade100,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(
            color: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }

  Widget productInputDropDown({
    String label,
    List items,
    Function onChanged,
    String value,
    bool isShowroom = false,
    String Function(dynamic) validator,
  }) {
    return textInputPadding(
      child: DropdownButtonFormField(
        validator: (value) => value == null ? 'Field can\'t be empty' : null,
        value: value,
        decoration: inputDecoration(label: label),
        isExpanded: true,
        iconEnabledColor: Colors.grey,
        style: inputTextStyle(),
        iconSize: 30,
        elevation: 9,
        onChanged: onChanged,
        items: items.map((e) {
          return DropdownMenuItem(
            value: isShowroom ? e.data['name'] : e,
            child: Text(isShowroom ? e.data['name'] : e),
          );
        }).toList(),
      ),
    );
  }

  Widget productInputText({
    TextEditingController controller,
    String label,
    TextInputType textInputType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.done,
    bool readOnly = false,
  }) {
    return textInputPadding(
      child: TextFormField(
        style: inputTextStyle(),
        readOnly: readOnly,
        maxLines: null,
        controller: controller,
        keyboardType: textInputType,
        decoration: inputDecoration(label: label),
        textInputAction: textInputAction,
      ),
    );
  }

  Widget productCard({
    String title,
    String description,
    String imageUrl,
    Function onTap,
  }) {
    return Card(
      margin: EdgeInsets.all(12),
      elevation: 3,
      shadowColor: Colors.deepPurple,
      child: ListTile(
        onTap: onTap,
        leading: CachedNetworkImage(
          imageUrl: imageUrl,
          height: 90,
          width: 90,
          filterQuality: FilterQuality.low,
        ),
        title: Text(capitalize(title)),
        subtitle: Text(description),
      ),
    );
  }

  Widget errorListTile() {
    return Container(
      margin: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.shade100,
      ),
      child: ListTile(
        title: nullWidget('404 Product not found !'),
      ),
    );
  }

  TabBar tabDecoration(String title1, String title2) {
    return TabBar(
      labelStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      indicatorColor: Colors.transparent,
      tabs: [Tab(text: title1), Tab(text: title2)],
    );
  }

  TextStyle inputTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 18,
      color: Colors.grey.shade700,
    );
  }

  inputDecoration({label, iconData, suffix}) {
    return InputDecoration(
      suffix: suffix,
      labelText: label,
      isDense: true,
      labelStyle: textStyle(color: Colors.red),
      contentPadding: EdgeInsets.all(16),
      border: InputBorder.none,
      fillColor: Colors.grey.shade100,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(9),
        borderSide: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      prefix: iconData != null
          ? SizedBox(
              height: 9,
              width: 9,
              child: Icon(
                iconData,
                color: Colors.red.shade300,
                size: 18,
              ),
            )
          : SizedBox(),
    );
  }

  void showSnackbar(String message) {
    Get.snackbar(
      'Alert',
      message,
      colorText: Colors.white,
      instantInit: true,
      margin: EdgeInsets.zero,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      snackStyle: SnackStyle.GROUNDED,
    );
  }

  container({Widget child}) {
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

  Widget appbar(label, {Widget boottom, Widget leading, List<Widget> actions}) {
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

  Widget nullWidget(label) {
    return Center(
      child: Text(
        label,
        style: textStyle(color: Colors.grey),
        textScaleFactor: 1.5,
        textAlign: TextAlign.center,
      ),
    );
  }

  progressIndicator() {
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

  Widget textInputPadding({child}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
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

  Widget listTile({
    String title,
    Function onTap,
    Widget leading,
    bool isTrailingNull = false,
    String subtitle,
  }) {
    return Container(
      margin: EdgeInsets.all(9),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        color: Colors.grey.shade50,
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
        title: Text(
          capitalize(title),
          style: TextStyle(color: Colors.red),
          textScaleFactor: 1.2,
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                capitalize(subtitle),
                style: TextStyle(
                  color: Colors.grey.shade700,
                ),
              ),
      ),
    );
  }

  Widget materialButton({Function onPressed, String title, Color color}) {
    return MaterialButton(
      height: 45,
      color: color,
      onPressed: onPressed,
      child: Text(
        title,
        style: textStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  String errorMessageHelper(String error) {
    switch (error) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        return "Your emai address is already in use";

      case "ERROR_INVALID_EMAIL":
        return "Email address appears to be malformed.";

      case "ERROR_WRONG_PASSWORD":
        return "Wrong Password";

      case "ERROR_USER_NOT_FOUND":
        return "User with this email doesn't exist.";

      case "ERROR_USER_DISABLED":
        return "Your Credintials are disabled , please contect Admin !";

      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests, Try again later.";

      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Signing in with Email and Password is not enabled.";

      default:
        return "Something went wrong , Try again later.";
    }
  }
}
