import 'package:flutter/material.dart';
import 'package:superuser/get/controllers.dart';

class Reports extends StatelessWidget {
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return controllers.utils.root(
        label: 'Reports',
        child: controllers.utils.streamBuilder(
          stream: controllers.reports.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.documents.length == 0) {
              return controllers.utils.error('No Reports Found !');
            } else {
              return ListView.builder(
                itemCount: snapshot.documents.length,
                itemBuilder: (context, index) {
                  return;
                },
              );
            }
          },
        ));
  }
}
