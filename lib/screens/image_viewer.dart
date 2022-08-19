import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewImage extends StatefulWidget {
  String url;

  ViewImage(this.url);

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: PhotoView(
            imageProvider: NetworkImage(widget.url),
          )
      ),
    );
  }
}
