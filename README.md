### An Image viewer like Zalo

## Features
* Cung cấp widget hiển thị hình ảnh có thao tác kéo thả để tắt và hiệu ứng Hero giống Zalo
* Không có xung đột cử chỉ vuốt xuống để tắt và cử chỉ phóng to
* Hiển thị ảnh bằng photo_view và cho phép kéo thả, phóng to, thu nhỏ, vuốt xuống tắt bằng 1 ngón tay

* Provide a widget to display images with drag and drop to close and Hero effect similar to Zalo
* Display photos using photo_view and allow dragging, zooming in, zooming out, swiping down to close with 1 finger to avoid conflicts with photo zoom gesture

* No conflict dismiss gesture with photo zoom gesture
* Show a single dimissible image
* Use pinch & zoom to zoom in and out of images
* double tap to zoom
* swipe down to dismiss

## Usage
Just use ImageView widget

```dart
import 'package:dismissible_image_view/view_image.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Viewer Package Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ImageGalleryScreen(),
    );
  }
}

class ImageGalleryScreen extends StatelessWidget {

  //Replace below links by your image urls
  final List<String> imageUrls = const [
    'image_url',
    'image_url',
    'image_url',
  ];

  const ImageGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dismissible Image Viewer Example'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          final imageUrl = imageUrls[index];
          final heroTag = 'image_$index';

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(
                    url: imageUrl,
                    heroTag: heroTag,
                  ),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error, color: Colors.red),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

```

## Additional information

Author: Thân Văn Dương/vanduongthan96@gmail.com
