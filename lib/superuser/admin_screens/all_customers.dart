import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/admin_extras/customer_details.dart';
import 'package:superuser/utils.dart';

class AllCustomers extends StatefulWidget {
  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  bool isSearchActive = false;
  final queryConroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isQueryActive = false;
  Firestore firestore = Firestore.instance;
  Utils utils = Utils();

  int count = 30;

  _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        count += 30;
      });
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: utils.getAppbar('Customers'),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: utils.getBoxDecoration(),
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
                      return utils.getNullWidget('No customers found !');
                    } else {
                      return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.grey.shade100,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        Customerdetails(
                                          docsnap: snapshot.data
                                              .documents[index],
                                        ),
                                  ),
                                );
                              },
                              title: Text(
                                '${snapshot.data.documents[index]['name']}',
                                style: TextStyle(
                                  color: Colors.red.shade300,
                                ),
                                textScaleFactor: 1.2,
                              ),
                              subtitle: Text(
                                  'Phone : ${snapshot.data
                                      .documents[index]['phone']}'),
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    return utils.getLoadingIndicator();
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
