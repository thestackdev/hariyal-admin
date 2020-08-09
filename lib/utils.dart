import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class Utils {
  /* TextStyle textStyle({Color color, double fontSize}) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      letterSpacing: 1.0,
      color: color,
    );
  } */

  Widget raisedButton(String label, Function onPressed) {
    return Center(
      child: RaisedButton(
        child: Text(label, style: Get.theme.textTheme.headline1),
        onPressed: onPressed,
      ),
    );
  }

  Widget paginator({
    Query query,
    Widget Function(int, BuildContext, DocumentSnapshot) itemBuilder,
  }) =>
      PaginateFirestore(
        emptyDisplay: error('No Data Found !'),
        initialLoader: loading(),
        bottomLoader: Padding(
          padding: EdgeInsets.all(9),
          child: loading(),
        ),
        itemsPerPage: 10,
        itemBuilder: itemBuilder,
        query: query,
        itemBuilderType: PaginateBuilderType.listView,
      );

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
        style: Get.theme.textTheme.headline2,
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
        style: Get.theme.textTheme.headline2,
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
  }) =>
      Card(
        child: ListTile(
          onTap: onTap,
          leading:
              CachedNetworkImage(imageUrl: imageUrl, height: 90, width: 90),
          title: Text(GetUtils.capitalize(title)),
          subtitle: Text(description),
        ),
      );

  void snackbar(String message) {
    if (Get.isSnackbarOpen) Get.back();
    Get.snackbar(
      null,
      message,
      margin: EdgeInsets.zero,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      snackStyle: SnackStyle.GROUNDED,
    );
  }

  Widget root(
      {String label, Widget bottom, Widget child, List<Widget> actions}) {
    try {
      return Scaffold(
        appBar: AppBar(
          actions: actions,
          title: Text(label, style: Get.textTheme.headline5),
          centerTitle: true,
          bottom: bottom,
        ),
        body: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: child,
          ),
        ),
      );
    } catch (e) {
      return error('Oops.. , Something went wrong !');
    }
  }

  Widget error(String text) => Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Text(
            text,
            style: Get.textTheme.headline4.apply(fontSizeFactor: 1.5),
          ),
        ),
      );

  Widget loading() => Center(child: SpinKitRing());

  Widget alertDialog(
      {String content, Function yesPressed, Function noPressed}) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Text('Are you sure'),
      content: Text(content),
      actions: [
        FlatButton(child: Text('Yes'), onPressed: yesPressed),
        FlatButton(child: Text('No'), onPressed: noPressed),
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
    return Card(
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

  Widget streamBuilder<T>({
    @required Stream<T> stream,
    @required Widget Function(BuildContext, T) builder,
  }) =>
      DataStreamBuilder<T>(
        stream: stream,
        builder: builder,
        loadingBuilder: (context) => loading(),
        errorBuilder: (context, e) => error('Oops.., Something went wrong !'),
      );

  Widget materialButton({Function onPressed, String title, Color color}) {
    return MaterialButton(
      height: 45,
      color: color,
      onPressed: onPressed,
      child: Text(title),
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
