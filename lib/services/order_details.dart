import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:superuser/get/controllers.dart';

class OrderDetails extends StatelessWidget {
  final oid;
  final controllers = Controllers.to;

  OrderDetails(this.oid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream:
              Firestore.instance.collection('orders').document(oid).snapshots(),
          builder: (streamContext, oSnap) {
            return oSnap == null
                ? controllers.utils.loading()
                : oSnap.hasData
                    ? StreamBuilder<DocumentSnapshot>(
                        stream: Firestore.instance
                            .collection('products')
                            .document(oSnap.data['pid'])
                            .snapshots(),
                        builder: (streamContext2, pSnap) {
                          return pSnap == null
                              ? controllers.utils.loading()
                              : pSnap.hasData
                                  ? buildUI(streamContext2, oSnap, pSnap)
                                  : controllers.utils
                                      .error('Something went wrong');
                        },
                      )
                    : controllers.utils.error('Something went wrong');
          },
        ),
      ),
    );
  }

  Widget buildUI(
      BuildContext streamContext2,
      AsyncSnapshot<DocumentSnapshot> oSnap,
      AsyncSnapshot<DocumentSnapshot> pSnap) {
    var date = new DateTime.fromMillisecondsSinceEpoch(oSnap.data['timeStamp']);
    String address = oSnap.data['address'];
    address = address.replaceAll(',', '\n');
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.all(12),
      children: [
        Text(
          'Order Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      'Order id',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      oSnap.data.documentID,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      'Order date',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                  ),
                  Container(
                    child: Text(
                      '${date.day}/${date.month}/${date.year}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      'Order total',
                      style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      '${oSnap.data['amount'].toString()} Rs.',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Shipment Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topLeft,
                height: 40,
                width: MediaQuery.of(streamContext2).size.width,
                child: oSnap.data['oStatus'] == 0
                    ? Image.asset('assets/booked.png')
                    : oSnap.data['oStatus'] == 1
                        ? Image.asset('assets/delivered.png')
                        : oSnap.data['oStatus'] == 2
                            ? Image.asset('assets/cancelled.png')
                            : Image.asset('assets/booked.png'),
              ),
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: pSnap.data['images'][0],
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.error_outline),
                      height: 120,
                      width: 160,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text(
                        pSnap.data['title'],
                        textScaleFactor: 1.4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.only(left: 12, right: 0.0),
                      subtitle: Text(
                        '₹ ${pSnap.data['price'].toString()}',
                        textScaleFactor: 1.2,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Payment Information',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 120,
                child: Text(
                  'Payment Id',
                  style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                ),
              ),
              Container(
                child: Text(
                  oSnap.data['payment_id'],
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Shipping Address',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Text(
              '${GetUtils.capitalize(
                oSnap.data['name'],
              )}, $address',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18)),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Order Summary',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'C-GST',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                  Text(
                    '0 Rs.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'S-GST',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                  Text(
                    '0 Rs.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Product Price',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                  Text(
                    '${pSnap.data['price'].toString()} Rs.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.start,
                  ),
                  Spacer(),
                  Text(
                    '${oSnap.data['amount']} Rs.',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[600],
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
