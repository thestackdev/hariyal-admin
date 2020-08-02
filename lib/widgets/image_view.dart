import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:superuser/get/controllers.dart';

class HariyalImageView extends StatefulWidget {
  final List imageUrls;

  const HariyalImageView({Key key, this.imageUrls}) : super(key: key);

  @override
  _HariyalImageViewState createState() => _HariyalImageViewState();
}

class _HariyalImageViewState extends State<HariyalImageView> {
  int currentIndex = 0;
  final controllers = Controllers.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Photo ${currentIndex + 1}/${widget.imageUrls.length}',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: PhotoViewGallery.builder(
        gaplessPlayback: true,
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(widget.imageUrls[index]),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained,
          );
        },
        itemCount: widget.imageUrls.length,
        loadingBuilder: (context, event) => Center(
          child: controllers.utils.progressIndicator(),
        ),
        loadFailedChild: controllers.utils.nullWidget('Something went wrong'),
        pageController: PageController(
          initialPage: 0,
          keepPage: true,
        ),
        onPageChanged: (value) {
          currentIndex = value;
          handleState();
        },
      ),
    );
  }

  handleState() => (mounted) ? setState(() => null) : null;
}
