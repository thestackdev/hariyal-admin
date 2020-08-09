import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class AllCustomers extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Customers',
      actions: [
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
      ],
      child: controllers.utils.paginator(
        query: controllers.customers.orderBy('timestamp', descending: true),
        itemBuilder: (index, context, snapshot) {
          try {
            return controllers.utils.listTile(
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(
                  snapshot['image'],
                ),
              ),
              title: '${snapshot['name']}',
              onTap: () => Get.toNamed('customer_deatils', arguments: snapshot),
            );
          } catch (e) {
            return controllers.utils.error(e.toString());
          }
        },
      ),
    );
  }
}
