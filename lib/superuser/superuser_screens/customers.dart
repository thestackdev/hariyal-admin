import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/services/search_page.dart';
import 'package:superuser/utils.dart';

class AllCustomers extends StatefulWidget {
  @override
  _AllCustomersState createState() => _AllCustomersState();
}

class _AllCustomersState extends State<AllCustomers> {
  final customers = Firestore.instance.collection('customers');
  final utils = Utils();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: utils.appbar('Customers', actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query': customers,
              'searchField': 'name',
              'type': 'customer'
            };
            Get.to(SearchPage(), arguments: map);
          },
        )
      ]),
      body: utils.container(
        child: utils.buildProducts(
          query: customers.orderBy('name'),
          itemBuilder: (context, snapshot) {
            try {
              return utils.listTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    snapshot['image'],
                  ),
                ),
                title: '${snapshot['name']}',
                onTap: () => Get.toNamed(
                  'customer_deatils',
                  arguments: snapshot,
                ),
              );
            } catch (e) {
              return utils.errorListTile();
            }
          },
        ),
      ),
    );
  }
}
