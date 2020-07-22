import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PNetworkImage extends StatelessWidget {
  final String image;
  final BoxFit fit;
  final double width, height;

  const PNetworkImage(this.image, {Key key, this.fit, this.height, this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) => Center(
        child: SpinKitRing(
          color: Colors.red.shade300,
          lineWidth: 3,
          size: 36,
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error_outline),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
