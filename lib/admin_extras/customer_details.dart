import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/services/product_details.dart';
import 'package:superuser/widgets/network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class Customerdetails extends StatelessWidget {
  final controllers = Controllers.to;
  final DocumentSnapshot snapshot = Get.arguments;

  @override
  Widget build(BuildContext context) {
    detailsPage() => Padding(
          padding: EdgeInsets.symmetric(horizontal: 9, vertical: 18),
          child: Wrap(
            spacing: 18,
            runSpacing: 18,
            children: <Widget>[
              buildDetails(snapshot['name'], 'Name'),
              buildDetailsWithActions(
                  snapshot['phone'], 'Phone', OMIcons.phone, false),
              buildDetailsWithActions(snapshot['alternatePhoneNumber'],
                  'Alternate Phone', OMIcons.phone, false),
              buildDetailsWithActions(
                  snapshot['email'], 'Email', OMIcons.email, true),
              buildDetails(snapshot['gender'], 'Gender'),
              buildDetails(snapshot['permanentAddress'], 'Permanent Address'),
              buildDetails(
                  snapshot['location']['cityDistrict'], 'City/District'),
              buildDetails(snapshot['location']['state'], 'State'),
            ],
          ),
        );

    interests() => controllers.utils.streamBuilder<QuerySnapshot>(
        stream: controllers.interests
            .orderBy('timestamp', descending: true)
            .where('author', isEqualTo: snapshot.documentID)
            .snapshots(),
        builder: (context, product) {
          print(product.documents.length);
          if (product.documents.length == 0)
            return controllers.utils.error('No Interests Found !');
          return ListView.builder(
              shrinkWrap: true,
              itemCount: product.documents.length,
              itemBuilder: (context, index) {
                try {
                  return controllers.utils.listTile(
                    title: product.documents[index]['title'],
                    leading: SizedBox(
                      width: 70,
                      child: PNetworkImage(
                        product.documents[index]['images'][0],
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    onTap: () => Get.to(
                      ProductDetails(),
                      arguments: product.documents[index].documentID,
                    ),
                  );
                } catch (e) {
                  return controllers.utils
                      .error('Oops , Something went wrong !');
                }
              });
        });

    return DefaultTabController(
      length: 2,
      child: controllers.utils.root(
        label: 'Customer Console',
        bottom: TabBar(
          tabs: <Widget>[Tab(text: 'Details'), Tab(text: 'Interests')],
        ),
        child: TabBarView(children: <Widget>[
          detailsPage(),
          interests(),
        ]),
      ),
    );
  }

  Widget buildDetails(String label, String data) => TextFormField(
        initialValue: GetUtils.capitalizeFirst(label),
        style: Get.textTheme.headline2,
        readOnly: true,
        decoration: InputDecoration(labelText: data),
      );
  Widget buildDetailsWithActions(
          String label, String data, IconData iconData, bool email) =>
      TextFormField(
        initialValue: GetUtils.capitalizeFirst(label),
        readOnly: true,
        style: Get.textTheme.headline2,
        decoration: InputDecoration(
          labelText: data,
          suffixIcon: IconButton(
              icon: Icon(iconData),
              onPressed: () {
                if (email) {
                  if (label != 'default') {
                    writeAnEmail(label);
                  } else {
                    controllers.utils.snackbar('Invalid Email Address');
                  }
                } else {
                  if (label != 'default') {
                    makeAPhone('tel: $label');
                  } else {
                    controllers.utils.snackbar('No Phone Number');
                  }
                }
              }),
        ),
      );

  void makeAPhone(String url) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        controllers.utils.snackbar('Something went wrong');
      }
    } catch (e) {
      controllers.utils.snackbar(e.toString());
    }
  }

  void writeAnEmail(String email) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto', path: email, queryParameters: {'subject': 'Hariyal'});
    try {
      if (await canLaunch(_emailLaunchUri.toString())) {
        await launch(_emailLaunchUri.toString());
      } else {
        controllers.utils.snackbar('Something went wrong');
      }
    } catch (e) {
      controllers.utils.snackbar(e.toString());
    }
  }
}
