import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';
import 'package:superuser/utils.dart';

class AllCustomers extends StatelessWidget {
  final customers = Controllers.to.customers;
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
            Get.toNamed('/search', arguments: map);
          },
        )
      ]),
      body: utils.container(
        child: utils.buildProducts(
          query: customers.orderBy('timestamp', descending: true),
          itemBuilder: (context, snapshot) {
            try {
              return utils.listTile(
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                    snapshot['image'],
                  ),
                ),
                title: '${snapshot['name']}',
                onTap: () =>
                    Get.toNamed('customer_deatils', arguments: snapshot),
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
