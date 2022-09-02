import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocViewer extends StatefulWidget {
  PDFDocument document;

  DocViewer(this.document);

  @override
  _DocViewerState createState() => _DocViewerState();
}

class _DocViewerState extends State<DocViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Example'),
      ),
      body: Center(
          child:PDFViewer(document: widget.document,)
      ),
    );
  }
}
