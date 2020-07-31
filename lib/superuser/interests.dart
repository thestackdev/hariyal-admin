import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_data_stream_builder/flutter_data_stream_builder.dart';
import 'package:get/get.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:superuser/utils.dart';

class Interests extends StatelessWidget {
  final firestore = Firestore.instance;
  final utils = Utils();

  @override
  Widget build(BuildContext context) {
    final products = firestore.collection('products');
    final interests = firestore.collection('interests');
    final customers = firestore.collection('customers');

    return Scaffold(
      appBar: utils.appbar('Interests'),
      body: utils.container(
        child: PaginateFirestore(
          emptyDisplay: utils.nullWidget('No products found !'),
          initialLoader: utils.blankScreenLoading(),
          bottomLoader: Padding(
            padding: EdgeInsets.all(9),
            child: utils.progressIndicator(),
          ),
          itemsPerPage: 10,
          query: interests.orderBy('timestamp', descending: true),
          itemBuilder: (context, snapshot) {
            return DataStreamBuilder<DocumentSnapshot>(
              stream: customers.document(snapshot.data['author']).snapshots(),
              builder: (context, author) {
                return DataStreamBuilder<DocumentSnapshot>(
                  stream:
                      products.document(snapshot.data['productId']).snapshots(),
                  builder: (context, product) {
                    return utils.listTile(
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
