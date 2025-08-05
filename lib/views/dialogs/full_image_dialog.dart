import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullscreenImagePage extends StatelessWidget {
  final Uint8List imageBytes;
  final Object heroTag;

  const FullscreenImagePage({
    super.key,
    required this.imageBytes,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(), // tap para cerrar
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Hero(
            tag: heroTag,
            child: PhotoView(
              imageProvider: MemoryImage(imageBytes),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.covered * 8, // zoom alto sin pixelarse
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
