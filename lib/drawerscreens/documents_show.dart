import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../constants.dart';
import '../databases/databases.dart';
import '../databases/documents.dart';

class DocumentsShow extends StatefulWidget {
  static const androidIcon = Icon(Icons.library_books);
  static const iosIcon = Icon(CupertinoIcons.news);

  const DocumentsShow({super.key, this.androidDrawer});

  final Widget? androidDrawer;

  @override
  State<DocumentsShow> createState() => _DocumentsShow();
}

class _DocumentsShow extends State<DocumentsShow> {
  var items = <Documents>[];
  var _index = 0;
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  @override
  void initState() {
    getDocumentsPictures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var platform = Theme.of(context).platform;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Papiers'),
        backgroundColor: color_background2,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.white,
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: FileImage(File(items[_index].image.toString())),
              initialScale: PhotoViewComputedScale.contained * 0.95,
              // heroAttributes: PhotoViewHeroAttributes(tag: items[index].id),
            );
          },
          itemCount: items.length,

          //  backgroundDecoration: widget.backgroundDecoration,
          pageController: _pageController,
          onPageChanged: onPageViewChange,
        ),
      ),
    );
  }


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  onPageViewChange(int page) {
    (page > _index) & (page < items.length)
        ? _index = _index + 1
        : _index = _index;
    (page < _index) & (page > 0)
        ? _index = _index - 1
        : _index = _index;
    _index = page;
    setState(() {});
  }

  getDocumentsPictures() async {
    final fromDb = await DatabaseClient().DocumentsPictures();
    setState(() {
      items = fromDb;
      print(items.length);
    });
  }

}
