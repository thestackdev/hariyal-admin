import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class Requests extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
      label: 'Requests',
      child: controllers.utils.streamBuilder(
          stream: controllers.products
              .orderBy('timestamp', descending: true)
              .where('authored', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) => (snapshot.documents.length == 0)
              ? controllers.utils.error('No Pending Requests !')
              : ListView.builder(
                  itemCount: snapshot.documents.length,
                  itemBuilder: (context, index) {
                    try {
                      return controllers.utils.card(
                        title: snapshot.documents[index].data['title'],
                        description:
                            snapshot.documents[index].data['description'],
                        imageUrl: snapshot.documents[index].data['images'][0],
                        onTap: () => Get.toNamed(
                          'product_details',
                          arguments: snapshot.documents[index].documentID,
                        ),
                      );
                    } catch (e) {
                      return controllers.utils
                          .error('Oops.., Somwthing went wrong');
                    }
                  },
                )),
    );
  }
}
