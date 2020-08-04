import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Interests extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: controllers.utils.appbar('Interests'),
      body: controllers.utils.container(
        child: controllers.utils.buildProducts(
          query: controllers.interests.orderBy('timestamp', descending: true),
          itemBuilder: (index, context, snapshot) {
            return DataStreamBuilder<DocumentSnapshot>(
              stream: controllers.customers
                  .document(snapshot.data['author'])
                  .snapshots(),
              builder: (context, author) {
                return DataStreamBuilder<DocumentSnapshot>(
                  stream: controllers.products
                      .document(snapshot.data['productId'])
                      .snapshots(),
                  builder: (context, product) {
                    return controllers.utils.listTile(
                        textscalefactor: 1,
                        leading: GestureDetector(
                          onTap: () => Get.offNamed(
                            'customer_deatils',
                            arguments: author,
                          ),
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              author.data['image'],
                            ),
                            backgroundColor: Colors.white,
                          ),
                        ),
                        onTap: () => Get.toNamed(
                              'product_details',
                              arguments: product.documentID,
                            ),
                        title:
                            '${author.data['name']} is interested in ${product['title']}');
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
