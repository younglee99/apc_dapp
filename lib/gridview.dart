import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ImageGridViewPage extends StatefulWidget {
  final String productTitle;

  const ImageGridViewPage({super.key, required this.productTitle});

  @override
  // ignore: library_private_types_in_public_api
  _ImageGridViewPageState createState() => _ImageGridViewPageState();
}

class _ImageGridViewPageState extends State<ImageGridViewPage> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference ref =
        storage.ref('images/${widget.productTitle}/');
    List<firebase_storage.Reference> resultList = (await ref.listAll()).items;

    List<String> urls = [];
    for (var item in resultList) {
      String downloadUrl = await item.getDownloadURL();
      urls.add(downloadUrl);
    }
    if (mounted) {
      setState(() {
        imageUrls = urls;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("                  ${widget.productTitle}"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(10),
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            width: 250,
            height: 400,
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
