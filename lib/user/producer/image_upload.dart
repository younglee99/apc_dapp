import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/contract.dart';

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
  String UID = userUID;
  List<String> imageUrls = [];

  Future<void> pickImages() async {
    multiImage = await picker.pickMultiImage();
    setState(() {
      imageDate = DateTime.now();
    });
  }

  Future<void> uploadImagesToFirebase(List<XFile?> images) async {
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

    for (int i = 0; i < images.length; i++) {
      XFile? image = images[i];
      if (image != null) {
        File file = File(image.path);
        // 업로드 경로 설정 (images 디렉토리 내에 image0.jpg, image1.jpg, ... 형태로 저장)
        firebase_storage.Reference ref =
            storage.ref().child('$UID/$productTitle/$i.jpg');
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
    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

    // 이미지 URL들을 저장할 리스트
    List<String> imageUrls = [];

    firebase_storage.Reference ref = storage.ref().child('$UID/$productTitle');

    List<firebase_storage.Reference> resultList = (await ref.listAll()).items;

    for (var item in resultList) {
      String downloadUrl = await item.getDownloadURL();
      imageUrls.add(downloadUrl);
    }
    String finalUrl = imageUrls.join(',');
    print(finalUrl);
    print(productTitle);
    createNote(userUID, productTitle, finalUrl);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("인증서 등록"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF256B66),
        elevation: 0,
      ),
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
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  width: w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: h * 0.02,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                productTitle = value.toLowerCase();
                              });
                            },
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  )),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  )),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 1.0,
                                  )),
                              hintText: "상품 이름",
                              prefixIcon: Icon(
                                Icons.paste_rounded,
                                color: Colors.lightGreen,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Center(
                        child: Row(
                          children: [
                            // 카메라로 찍기
                            Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.green,
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
                                  final image = await picker.pickImage(
                                      source: ImageSource.camera);
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
                                color: Colors.green,
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
                      ),
                      Container(
                        width: w,
                        height: h * 0.55,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(0),
                          shrinkWrap: true,
                          itemCount: multiImage.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 0.01,
                ),
                // 인증서 등록 버튼
                GestureDetector(
                  onTap: () async {
                    if (productTitle.isNotEmpty) {
                      if (productTitleList.contains(productTitle)) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('오류'),
                              content: const Text('이미 같은 제품이 존재합니다.'),
                              actions: [
                                TextButton(
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('인증서 등록'),
                              content: const Text('이미지를 업로드하시겠습니까?\n등록 시 수정이 불가합니다.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("취소"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    widget.updateLoading(true);
                                    uploadImagesToFirebase(multiImage);
                                    Navigator.pop(context);
                                  },
                                  child: Text("확인"),
                                ),
                              ],
                            );
                          },
                        );
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
                              TextButton(
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
                  child: Container(
                      width: w * 0.5,
                      height: h * 0.07,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage("img/btn.png"),
                              fit: BoxFit.cover)),
                      child: Center(
                        child: Text(
                          "인증서 등록",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
