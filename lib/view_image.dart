library;

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'dismissable_page/dismissible_page.dart';

class ImageView extends StatefulWidget {
  final String url;
  final String heroTag;
  final ImageProvider? imageProvider;

  const ImageView({
    super.key,
    this.url = '',
    required this.heroTag,
    this.imageProvider,
  });

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  bool _isZooming = false;
  PhotoViewScaleStateController? _scaleController;
  PhotoViewControllerBase? _photoController;

  void _scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    _visibleButtonClose(scaleState != PhotoViewScaleState.initial);
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void _visibleButtonClose(bool isZooming) {
    if (_isZooming != isZooming) {
      setState(() {
        _isZooming = isZooming;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scaleController = PhotoViewScaleStateController();
    _photoController = PhotoViewController();
  }

  @override
  void dispose() {
    _scaleController?.dispose();
    super.dispose();
  }

  bool _isDragging = false;

  bool get _isVisibleButtonClose => !_isZooming && !_isDragging;

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      key: Key(widget.heroTag),
      dragSensitivity: 1,
      minScale: 0.1,
      allowMultiPointer: false,
      onDragUpdate: (detail) {
        if (_isZooming) return;
        setState(() {
          _isDragging = detail.scale != 1;
        });
      },
      isPauseGesture: _isZooming,
      direction: _isZooming
          ? DismissiblePageDismissDirection.none
          : DismissiblePageDismissDirection.down,
      onDismissed: () {
        Navigator.pop(context);
      },
      child: Stack(
        children: [
          PhotoView(
            heroAttributes: PhotoViewHeroAttributes(
                tag: widget.heroTag, transitionOnUserGestures: true),
            gestureDetectorBehavior: HitTestBehavior.opaque,
            maxScale: PhotoViewComputedScale.contained * 4,
            minScale: PhotoViewComputedScale.contained,
            imageProvider: widget.imageProvider ?? NetworkImage(widget.url),
            backgroundDecoration: BoxDecoration(
                color: _isDragging ? Colors.transparent : Colors.black),
            scaleStateController: _scaleController,
            controller: _photoController,
            scaleStateChangedCallback: _scaleStateChangedCallback,
          ),
          // (Tùy chọn) Thêm nút đóng hoặc các UI khác ở đây, dựa vào _isVisibleButtonClose
          if (_isVisibleButtonClose)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
        ],
      ),
    );
  }
}
