import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:trust_blockchain/global_variable.dart';

class ImageGridViewPage extends StatefulWidget {
  final String productTitle;
  final String? farmUID;

  const ImageGridViewPage(
      {super.key, required this.productTitle, required this.farmUID});

  @override
  // ignore: library_private_types_in_public_api
  _ImageGridViewPageState createState() => _ImageGridViewPageState();
}

class _ImageGridViewPageState extends State<ImageGridViewPage> {
  List<String> imageUrls = [];
  String UID = '';

  @override
  void initState() {
    super.initState();
    fetchImageUrls();
  }

  Future<void> fetchImageUrls() async {
    if (widget.farmUID != '') {
      UID = widget.farmUID!;
    } else {
      UID = userUID;
    }

    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    firebase_storage.Reference ref =
        storage.ref('$UID/${widget.productTitle}/');
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {Navigator.pop(context);},
              icon: Icon(Icons.arrow_back),
            ),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
            title: Text("${widget.productTitle}"),
            backgroundColor: Color(0xFF256B66),
            elevation: 0),
        body: Stack(
          children: [
            Container(
              width: w,
              height: h * 0.2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/background.png"),
                      fit: BoxFit.cover)),
            ),
            ListView.builder(
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
          ],
        ));
  }
}
