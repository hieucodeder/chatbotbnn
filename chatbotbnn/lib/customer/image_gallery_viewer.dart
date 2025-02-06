import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGalleryViewer extends StatelessWidget {
  final List<String> imageUrls; // Danh sách đường dẫn ảnh
  final int initialIndex; // Ảnh đầu tiên hiển thị khi mở
  final PageController pageController;

  ImageGalleryViewer({
    required this.imageUrls,
    this.initialIndex = 0,
  }) : pageController = PageController(initialPage: initialIndex);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          child: PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            pageController: pageController,
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.0,
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
              );
            },
            scrollPhysics: const BouncingScrollPhysics(), // Hiệu ứng cuộn mượt
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? 0
                    : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
