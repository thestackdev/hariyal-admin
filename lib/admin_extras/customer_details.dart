import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
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
          scheme: 'mailto',
          path: email,
          queryParameters: {'subject': 'Hariyal'});
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

    detailsPage() {
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        children: <Widget>[
          SizedBox(height: 18),
          TextFormField(
            initialValue: GetUtils.capitalizeFirst(
              snapshot['name'] ?? 'Something went wrong !',
            ),
            readOnly: true,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue: snapshot['phone'] ?? 'Something went wrong !',
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Phone',
              suffixIcon: IconButton(
                icon: Icon(OMIcons.phone),
                onPressed: () => makeAPhone('tel: ${snapshot['phone']}'),
              ),
            ),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue: snapshot['email'] ?? 'Something went wrong !',
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Email',
              suffixIcon: IconButton(
                  icon: Icon(OMIcons.email),
                  onPressed: () {
                    if (snapshot['email'] != 'default') {
                      writeAnEmail(
                        snapshot['email'],
                      );
                    } else {
                      controllers.utils.snackbar('Invalid Email Address');
                    }
                  }),
            ),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue: snapshot['gender'] ?? 'Something went wrong !',
            readOnly: true,
            decoration: InputDecoration(labelText: 'Gender'),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue:
                snapshot['alternatePhoneNumber'] ?? 'Something went wrong !',
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Alternate Phone',
              suffixIcon: IconButton(
                icon: Icon(OMIcons.phone),
                onPressed: () {
                  if (snapshot['alternatePhoneNumber'] != 'default') {
                    makeAPhone('tel: ${snapshot['alternatePhoneNumber']}');
                  } else {
                    controllers.utils.snackbar('No Phone Number');
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue:
                snapshot['permanentAddress'] ?? 'Something went wrong !',
            readOnly: true,
            decoration: InputDecoration(labelText: 'Permanent Address'),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue: GetUtils.capitalize(
              snapshot['location']['cityDistrict'] ?? 'Something went wrong !',
            ),
            readOnly: true,
            decoration: InputDecoration(labelText: 'City/District'),
          ),
          SizedBox(height: 18),
          TextFormField(
            initialValue: GetUtils.capitalize(
              snapshot['location']['state'] ?? 'Something went wrong !',
            ),
            readOnly: true,
            decoration: InputDecoration(labelText: 'State'),
          ),
        ],
      );
    }

    return DefaultTabController(
      length: 2,
      child: controllers.utils.root(
        label: 'Customer Console',
        bottom: TabBar(
          indicatorColor: Colors.transparent,
          tabs: <Widget>[Tab(text: 'Details'), Tab(text: 'Interests')],
        ),
        child: TabBarView(children: <Widget>[
          detailsPage(),
          controllers.utils.paginator(
            query: controllers.interests
                .orderBy('timestamp', descending: true)
                .where('author', isEqualTo: snapshot.documentID),
            itemBuilder: (index, context, snapshot) {
              return DataStreamBuilder<DocumentSnapshot>(
                stream: controllers.products
                    .document(snapshot['productId'])
                    .snapshots(),
                builder: (context, product) {
                  try {
                    return controllers.utils.listTile(
                      title: '${product.data['title']}',
                      leading: SizedBox(
                        width: 70,
                        child: PNetworkImage(
                          product.data['images'][0],
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      onTap: () => Get.to(
                        ProductDetails(),
                        arguments: product.documentID,
                      ),
                    );
                  } catch (e) {
                    return controllers.utils
                        .error('Oops , Something went wrong !');
                  }
                },
              );
            },
          ),
        ]),
      ),
    );
  }
}
