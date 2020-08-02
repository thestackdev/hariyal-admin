import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class AllCustomers extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Customers', actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            Map<dynamic, dynamic> map = {
              'query': controllers.customers,
              'searchField': 'name',
              'type': 'customer'
            };
            Get.toNamed('/search', arguments: map);
          },
        )
      ]),
      body: controllers.utils.container(
        child: controllers.utils.buildProducts(
          query: controllers.customers.orderBy('timestamp', descending: true),
          itemBuilder: (context, snapshot) {
            try {
              return controllers.utils.listTile(
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
              return controllers.utils.nullWidget(e.toString());
            }
          },
        ),
      ),
    );
  }
}
