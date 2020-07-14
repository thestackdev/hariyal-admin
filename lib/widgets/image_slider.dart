import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'dot_indicator.dart';
import 'network_image.dart';

class ImageSliderWidget extends StatefulWidget {
  final List<dynamic> imageUrls;
  final BorderRadius imageBorderRadius;
  final double imageHeight;
  final dynamic tag;
  final fit;

  final double dotPosition;

  final GestureTapCallback onTap;
  final isZoomable;

  const ImageSliderWidget(
      {this.tag,
      this.imageUrls,
      this.imageBorderRadius,
      this.imageHeight,
      this.onTap,
      this.isZoomable,
      this.fit,
      this.dotPosition});

  @override
  ImageSliderWidgetState createState() {
    return new ImageSliderWidgetState();
  }
}

class ImageSliderWidgetState extends State<ImageSliderWidget> {
  List<Widget> _pages = [];

  int page = 0;

  final _controller = PageController();

  @override
  void initState() {
    super.initState();
    _pages = widget.imageUrls.map((url) {
      return widget.isZoomable == null
          ? _buildImagePageItem(url, widget.tag, widget.onTap)
          : widget.isZoomable
              ? _buildZoomablePageItem(url, widget.tag)
              : _buildImagePageItem(url, widget.tag, widget.onTap);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _buildingImageSlider();
  }

  Widget _buildingImageSlider() {
    return Container(
      height: widget.imageHeight == null
          ? MediaQuery.of(context).size.height / 1.5
          : widget.imageHeight,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        elevation: 4.0,
        child: Stack(
          children: [
            _buildPagerViewSlider(),
            _buildDotsIndicatorOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildPagerViewSlider() {
    return Positioned.fill(
      child: PageView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _controller,
        itemCount: _pages.length,
        itemBuilder: (BuildContext context, int index) {
          return _pages[index % _pages.length];
        },
        onPageChanged: (int p) {
          setState(() {
            page = p;
          });
        },
      ),
    );
  }

  Positioned _buildDotsIndicatorOverlay() {
    return Positioned(
      bottom: widget.dotPosition != null
          ? widget.dotPosition
          : MediaQuery.of(context).size.height / 8,
      left: 0.0,
      right: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DotsIndicator(
          controller: _controller,
          itemCount: _pages.length,
          onPageSelected: (int page) {
            _controller.animateToPage(
              page,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }

  Widget _buildZoomablePageItem(String imgUrl, dynamic key) {
    return PhotoView(
      heroAttributes: PhotoViewHeroAttributes(tag: key),
      imageProvider: CachedNetworkImageProvider(imgUrl),
      loadingBuilder: (context, event) => Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildImagePageItem(
      String imgUrl, dynamic key, GestureTapCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: widget.tag,
        child: ClipRRect(
          borderRadius: widget.imageBorderRadius == null
              ? BorderRadius.circular(8.0)
              : widget.imageBorderRadius,
          child: PNetworkImage(
            imgUrl,
            fit: widget.fit == null ? BoxFit.contain : widget.fit,
          ),
        ),
      ),
    );
  }
}
