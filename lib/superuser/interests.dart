import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Interests extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) => controllers.utils.root(
        label: 'Interests',
        child: controllers.utils.paginator(
          query: controllers.interests.orderBy('timestamp', descending: true),
          itemBuilder: (index, context, snapshot) =>
              controllers.utils.streamBuilder(
            stream: controllers.customers
                .document(snapshot.data['author'])
                .snapshots(),
            builder: (context, author) => controllers.utils.streamBuilder(
              stream: controllers.products
                  .document(snapshot.data['productId'])
                  .snapshots(),
              builder: (context, product) => controllers.utils.listTile(
                  textscalefactor: 1,
                  leading: GestureDetector(
                    onTap: () =>
                        Get.offNamed('customer_deatils', arguments: author),
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        author.data['image'],
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  onTap: () => Get.toNamed('product_details',
                      arguments: product.documentID),
                  title:
                      '${author.data['name']} is interested in ${product['title']}'),
            ),
          ),
        ),
      );
}
