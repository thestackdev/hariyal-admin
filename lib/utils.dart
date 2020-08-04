import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class Utils {
  TextStyle textStyle({Color color, double fontSize}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      letterSpacing: 1.0,
      color: color,
    );
  }

  Widget raisedButton(String label, Function onPressed) {
    return Center(
      child: RaisedButton(
        child: Text(label),
        onPressed: onPressed,
      ),
    );
  }

  Widget buildProducts(
      {Query query,
      Widget Function(int, BuildContext, DocumentSnapshot) itemBuilder,
      bool shrinkWrap = false,
      PaginateBuilderType builderType = PaginateBuilderType.listView}) {
    return PaginateFirestore(
      shrinkWrap: shrinkWrap,
      emptyDisplay: nullWidget('Nothing found'),
      initialLoader: progressIndicator(),
      bottomLoader: Padding(
        padding: EdgeInsets.all(9),
        child: progressIndicator(),
      ),
      itemsPerPage: 10,
      itemBuilder: itemBuilder,
      query: query,
      itemBuilderType: builderType,
    );
  }

  bool validateInputText(String text) =>
      (text.trim().length > 0 && !text.contains('.')) ? true : false;

  Widget dismissible({
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
        child: Center(
          child: ListTile(
            leading: Icon(
              OMIcons.deleteForever,
              color: Colors.white,
            ),
          ),
        ),
      ),
      secondaryBackground: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          color: Colors.blue,
        ),
        child: Center(
          child: ListTile(
            trailing: Icon(
              OMIcons.edit,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> getSimpleDialouge(
      {String title,
      yesText,
      noText,
      Function yesPressed,
      Function noPressed,
      Widget content}) {
    if (noText == null) noText = 'Cancel';

    if (yesText == null) yesText = 'Confirm';

    return Get.dialog(
      AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Center(child: Text(title)),
        content: content,
        actions: <Widget>[
          FlatButton(
            child: Text(noText),
            onPressed: noPressed,
          ),
          FlatButton(
            child: Text(yesText),
            onPressed: yesPressed,
          ),
        ],
      ),
    );
  }

  Widget dialogInput({
    String hintText,
    Function(String) onChnaged,
    String initialValue,
    TextEditingController controller,
    Function(String) validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      validator: (value) => value == null ? 'Field can\'t be empty' : null,
      onChanged: onChnaged,
      decoration: InputDecoration(hintText: hintText),
    );
  }

  Widget productInputDropDown({
    String label,
    List items,
    Function onChanged,
    String value,
    bool isShowroom = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      child: DropdownButtonFormField(
        validator: (value) => value == null ? 'Field can\'t be empty' : null,
        value: value,
        decoration: InputDecoration(labelText: label),
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

  Widget inputTextField(
      {TextEditingController controller,
      String label,
      TextInputType textInputType = TextInputType.text,
      TextInputAction textInputAction = TextInputAction.done,
      Function(String) onChanged,
      bool readOnly = false,
      String initialValue,
      List<TextInputFormatter> inputFormatters}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      child: TextFormField(
        initialValue: initialValue,
        validator: (value) =>
            value == null || value.isEmpty ? 'Field can\'t be empty' : null,
        onChanged: onChanged,
        style: inputTextStyle(),
        readOnly: readOnly,
        maxLines: null,
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: textInputType,
        decoration: InputDecoration(labelText: label),
        textInputAction: textInputAction,
      ),
    );
  }

  Widget card({
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
        title: Text(GetUtils.capitalize(title)),
        subtitle: Text(description),
      ),
    );
  }

  TextStyle inputTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 16,
      color: Colors.grey.shade700,
    );
  }

  void showSnackbar(String message) {
    if (Get.isSnackbarOpen) Get.back();
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

  Widget appbar(
    String label, {
    Widget bottom,
    List<Widget> actions,
  }) {
    return AppBar(
      actions: actions,
      title: Text(GetUtils.capitalizeFirst(label)),
      centerTitle: true,
      bottom: bottom,
    );
  }

  Widget nullWidget(String label) {
    return Center(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade700),
        textScaleFactor: 1.5,
      ),
    );
  }

  Widget progressIndicator() {
    return Center(
      child: SpinKitRing(color: Colors.red.shade300, lineWidth: 5),
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
    double textscalefactor,
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
                OMIcons.chevronRight,
                color: Colors.red,
              ),
        onTap: onTap,
        title: Text(
          GetUtils.capitalizeFirst(title.trim()),
          style: TextStyle(color: Colors.red),
          textScaleFactor: textscalefactor ?? 1.2,
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                GetUtils.capitalizeFirst(subtitle),
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
        return "Emai address is already in use";

      case "ERROR_INVALID_EMAIL":
        return "Invalid Email Adress";

      case "ERROR_WRONG_PASSWORD":
        return "Wrong Password";

      case "ERROR_USER_NOT_FOUND":
        return "User with this email doesn't exist";

      case "ERROR_USER_DISABLED":
        return "Your Account is disabled , please contact Admin !";

      case "ERROR_TOO_MANY_REQUESTS":
        return "Too many requests, Try again later.";

      case "ERROR_OPERATION_NOT_ALLOWED":
        return "Signing in with Email and Password is not enabled.";

      default:
        return "Something went wrong , Try again later.";
    }
  }
}
