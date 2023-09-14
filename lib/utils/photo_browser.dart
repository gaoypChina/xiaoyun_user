import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:xiaoyun_user/constant/constant.dart';

class PhotoBrowser extends StatefulWidget {
  final List photoUrls;
  final int initialIndex;

  const PhotoBrowser({
    super.key,
    required this.photoUrls,
    this.initialIndex = 0,
  });

  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  late PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          GestureDetector(
            child: PhotoViewGallery.builder(
              itemCount: widget.photoUrls.length,
              pageController: _pageController,
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      CachedNetworkImageProvider(widget.photoUrls[index]),
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.photoUrls[index]),
                );
              },
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                        (event.expectedTotalBytes??1),
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          if (widget.photoUrls.length > 1)
            SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(bottom: 20),
                child: SmoothPageIndicator(
                  controller: _pageController,
                  count: widget.photoUrls.length,
                  effect: WormEffect(
                    dotWidth: 10,
                    dotHeight: 10,
                    activeDotColor: DYColors.primary,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
