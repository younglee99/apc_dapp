import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../variable.dart';
import '../contract.dart';

class ImageUpload extends StatefulWidget {
  final Future<void> Function() updateFunction;
  final void Function(bool) updateLoading;
  const ImageUpload(
      {Key? key, required this.updateFunction, required this.updateLoading})
      : super(key: key);

  @override
  State<ImageUpload> createState() => ImageUploadState();
}

class ImageUploadState extends State<ImageUpload> {
  DateTime imageDate = DateTime.now();
  final picker = ImagePicker();
  List<XFile?> multiImage = [];
  String productTitle = "";
  List<String> imageUrls = [];

  Future<void> pickImages() async {
    multiImage = await picker.pickMultiImage();
    setState(() {
      imageDate = DateTime.now();
    });
  }

  Future<void> uploadImagesToFirebase(List<XFile?> images) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    for (int i = 0; i < images.length; i++) {
      XFile? image = images[i];
      if (image != null) {
        File file = File(image.path);
        // 업로드 경로 설정 (images 디렉토리 내에 image0.jpg, image1.jpg, ... 형태로 저장)
        firebase_storage.Reference ref =
            storage.ref().child('images/$productTitle/$i.jpg');
        await ref.putFile(file);
        await ref.updateMetadata(
          firebase_storage.SettableMetadata(
            customMetadata: {'date': imageDate.toIso8601String()},
          ),
        );
      }
    }
    widget.updateFunction();
    uploadContract();
  }

  Future<void> uploadContract() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    // 이미지 URL들을 저장할 리스트
    List<String> imageUrls = [];

    firebase_storage.Reference ref =
        storage.ref().child('images/$productTitle');

    List<firebase_storage.Reference> resultList = (await ref.listAll()).items;

    for (var item in resultList) {
      String downloadUrl = await item.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    String finalUrl = imageUrls.join(',');
    print(finalUrl);
    print(productTitle);
    createNote(uid, productTitle, finalUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text("            인증서 등록",
            style: TextStyle(color: Colors.black)),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 50,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.all(5),
              alignment: Alignment.centerLeft,
              child: const Text(
                '상품 이름',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Title',
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.title)),
              onChanged: (value) {
                setState(() {
                  productTitle = value.toLowerCase();
                });
              },
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.all(3),
              margin: const EdgeInsets.only(top: 5),
              alignment: Alignment.bottomLeft,
              child: const Text(
                '이미지 넣기',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              children: [
                // 카메라로 촬영하기
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final image =
                          await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        setState(() {
                          multiImage.add(image);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
                // 갤러리에서 가져오기
                Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: pickImages,
                    icon: const Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: multiImage.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return Image.file(
                    File(multiImage[index]!.path),
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (productTitle.isNotEmpty) {
                  if (productTitles.contains(productTitle)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('오류'),
                          content: const Text('이미 같은 제품이 존재합니다.'),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('확인'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    widget.updateLoading(true);
                    uploadImagesToFirebase(multiImage);
                    Navigator.pop(context);
                  }
                  // 업로드 완료 후 추가 작업 수행 가능
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('오류'),
                        content: const Text('제품 이름을 입력하세요.'),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('확인'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('인증서 등록'),
            ),
          ],
        ),
      ),
    );
  }
}
