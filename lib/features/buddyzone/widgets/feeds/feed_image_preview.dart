import 'dart:io';
import 'package:flutter/material.dart';

class FeedImagePreview extends StatelessWidget {
  final File imageFile;
  final VoidCallback onDelete;

  const FeedImagePreview({
    super.key,
    required this.imageFile,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 65.0, right: 16.0),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              clipBehavior: Clip.hardEdge,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.file(imageFile, fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
        Positioned(
          top: 10,
          right: 26,
          child: GestureDetector(
            onTap: onDelete,
            child: const Image(
              width: 20,
              height: 20,
              image: AssetImage('assets/buddyzone/del_image.png'),
            ),
          ),
        ),
      ],
    );
  }
}
