import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignResister extends StatefulWidget {
  const SignResister({Key? key}) : super(key: key);

  @override
  State<SignResister> createState() => _SignResisterState();
}

class _SignResisterState extends State<SignResister> {
  DateTime imageDate = DateTime.now();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _signatureImage; // 선택한 이미지를 저장하는 변수
  String signUrl = '';

  @override
  void initState() {
    super.initState();
    getsignFromFirebase();
  }

  Future<void> pickSignImage() async {
    final pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _signatureImage = pickedImage; // 이미지 선택 후 상태 업데이트
      });
    }
  }

  Future<void> uploadsignToFirebase(XFile? sign) async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    XFile? image = sign;
    if (image != null) {
      File file = File(image.path);
      // 업로드 경로 설정 (images 디렉토리 내에 image0.jpg, image1.jpg, ... 형태로 저장)
      firebase_storage.Reference ref =
          storage.ref().child('images/sign/mysign.jpg');
      await ref.putFile(file);
      await ref.updateMetadata(
        firebase_storage.SettableMetadata(
          customMetadata: {'date': imageDate.toIso8601String()},
        ),
      );
      getsignFromFirebase(); // 이미지 업로드 후 다시 이미지를 가져옵니다.
    }
  }

  Future<void> getsignFromFirebase() async {
    firebase_storage.FirebaseStorage storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      // 이미지가 저장된 경로를 참조합니다.
      firebase_storage.Reference ref =
          storage.ref().child('images/sign/mysign.jpg');

      // 이미지의 URL을 가져옵니다.
      final imageUrl = await ref.getDownloadURL();

      if (mounted) {
        setState(() {
          signUrl = imageUrl;
        });
      }
    } catch (e) {
      // 이미지를 불러오는데 실패한 경우 "현재 등록된 서명이 없습니다" 문구를 표시합니다.
      if (mounted) {
        setState(() {
          signUrl = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text("서명 등록", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50),
          if (signUrl.isNotEmpty)
            SizedBox(
              height: 200,
              width: 200,
              child: Image.network(
                signUrl,
                fit: BoxFit.cover,
              ),
            ),
          if (signUrl.isEmpty)
            const Text(
              "현재 등록된 서명이 없습니다.",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: SizedBox(
              height: 40,
              width: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 145, 226, 148),
                  foregroundColor: const Color.fromARGB(255, 9, 85, 53),
                  shadowColor: const Color.fromARGB(255, 153, 214, 155),
                  elevation: 10,
                ),
                onPressed: () {
                  pickSignImage();
                },
                child: const Text("서명 등록",
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 40,
            width: 100,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 145, 226, 148),
                foregroundColor: const Color.fromARGB(255, 9, 85, 53),
                shadowColor: const Color.fromARGB(255, 153, 214, 155),
                elevation: 10,
              ),
              onPressed: () {
                uploadsignToFirebase(_signatureImage);
                Navigator.pop(context);
              },
              child: const Text("서명 저장",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
