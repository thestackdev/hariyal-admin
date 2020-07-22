import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/admin_extras/customer_tabs.dart';
import 'package:superuser/utils.dart';

class AllCustomers extends StatefulWidget {
  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  bool isSearchActive = false;
  final queryConroller = TextEditingController();
  bool isQueryActive = false;
  Firestore firestore = Firestore.instance;
  Utils utils = Utils();
  int count = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Customers'),
      body: utils.container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(9),
              child: TextField(
                style: TextStyle(color: Colors.grey, fontSize: 16),
                maxLines: null,
                controller: queryConroller,
                decoration: getDecoration(),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: isQueryActive
                    ? firestore
                        .collection('customers')
                        .where('name', isEqualTo: queryConroller.text)
                        .limit(count)
                        .snapshots()
                    : firestore
                        .collection('customers')
                        .limit(count)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.documents.length == 0) {
                      return utils.nullWidget('No customers found !');
                    } else {
                      return LazyLoadScrollView(
                        onEndOfPage: () {
                          count += 30;
                          handleState();
                        },
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return utils.listTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data.documents[index]['image']),
                              ),
                              title:
                                  '${snapshot.data.documents[index]['name']}',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => Customerdetails(
                                      docsnap: snapshot.data.documents[index],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else {
                    return utils.progressIndicator();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getDecoration() {
    return InputDecoration(
      isDense: true,
      labelStyle: TextStyle(
        color: Colors.red.shade300,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: 1.0,
      ),
      hintText: 'search by name',
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.accountSearchOutline),
            onPressed: () {
              if (queryConroller.text.length > 0) {
                isQueryActive = true;
                FocusScope.of(context).unfocus();
                handleState();
              }
            },
          ),
          isQueryActive
              ? IconButton(
                  icon: Icon(MdiIcons.closeOutline),
                  onPressed: () {
                    if (isQueryActive) {
                      FocusScope.of(context).unfocus();
                      queryConroller.clear();
                      isQueryActive = false;
                      handleState();
                    }
                  },
                )
              : SizedBox()
        ],
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
    );
  }

  handleState() {
    if (mounted) {
      setState(() {});
    }
  }
}
