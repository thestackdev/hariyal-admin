import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:superuser/admin_extras/customer_details.dart';

class AllCustomers extends StatefulWidget {
  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  bool isSearchActive = false;
  final queryConroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool isQueryActive = false;

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
    return ListView(
      shrinkWrap: true,
      controller: _scrollController,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(9),
          child: TextField(
            maxLines: null,
            controller: queryConroller,
            decoration: getDecoration(),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: isQueryActive
                ? Firestore.instance
                    .collection('customers')
                    .where('name', isEqualTo: queryConroller.text)
                    .limit(count)
                    .snapshots()
                : Firestore.instance
                    .collection('customers')
                    .limit(count)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey.shade200,
                      ),
                      child: ListTile(
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
                        title: Text(
                            'Name : ${snapshot.data.documents[index]['name']}'),
                        subtitle: Text(
                            'Phone : ${snapshot.data.documents[index]['phoneNumber']}'),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
      ],
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
                setState(() {
                  isQueryActive = true;
                });
              }
            },
          ),
          isQueryActive
              ? IconButton(
                  icon: Icon(MdiIcons.closeOutline),
                  onPressed: () {
                    if (isQueryActive) {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        queryConroller.clear();
                        isQueryActive = false;
                      });
                    }
                  },
                )
              : SizedBox()
        ],
      ),
      contentPadding: EdgeInsets.all(18),
      border: InputBorder.none,
      fillColor: Colors.grey.shade200,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
