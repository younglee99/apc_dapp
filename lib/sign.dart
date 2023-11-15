import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:get/get.dart';
import 'package:trust_blockchain/database.dart';
import 'package:trust_blockchain/global_variable.dart';

class SignaturePadScreen extends StatefulWidget {
  const SignaturePadScreen({super.key});

  @override
  State<SignaturePadScreen> createState() => _SignaturePadScreenState();
}

class _SignaturePadScreenState extends State<SignaturePadScreen> {
  final GlobalKey<SignatureState> _sign = GlobalKey();
  ByteData _img = ByteData(0);
  double strokeWidth = 5.0;
  String UID = userUID;
  String Name = userName;
  bool hasSignature = false;

  @override
  void initState() {
    super.initState();
    _loadSignature();
  }

  Future<void> _loadSignature() async {
    // 데이터베이스에서 서명 데이터를 가져와서 이미지로 변환
    SignatureDatabase signatureDB = SignatureDatabase();
    await signatureDB.initializeDatabase();
    List<String> signatures = await signatureDB.getAllSignatures();

    if (signatures.isNotEmpty) {
      setState(() {
        hasSignature = true;
        _img = _loadImageFromSignature(signatures.last); // 이 데이터를 qr에 넣는다
      });
    }
  }

  ByteData _loadImageFromSignature(String signatureData) {
    Uint8List signatureBytes = base64Decode(signatureData);
    return ByteData.sublistView(signatureBytes);
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Color(0xFF256B66),
          actions: [
            IconButton(
                onPressed: () {
                  final sign = _sign.currentState;
                  sign!.clear();
                },
                icon: Icon(Icons.delete))
          ],
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
          Column(
            children: [
              // 서명해주세여
              Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: const Text(
                  '네모칸 안에 서명해주세요',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: h * 0.02,
              ),
              // 네모칸
              if (hasSignature)
                Container(
                    width: w * 0.9,
                    height: h * 0.5,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7,
                            spreadRadius: 5,
                            offset: Offset(0, 3))
                      ],
                    ),
                    child: Center(
                      child: Image.memory(_img.buffer.asUint8List()),
                    ))
              else
                Container(
                  width: w * 0.9,
                  height: h * 0.5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          spreadRadius: 5,
                          offset: Offset(0, 3))
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Signature(
                      color: Colors.black, // Keep the color black
                      key: _sign,
                      onSign: () {
                        final sign = _sign.currentState;
                        debugPrint(
                            '${sign!.points.length} points in the signature');
                      },
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
              SizedBox(
                height: h * 0.1,
              ),
              // 버튼들
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!hasSignature)
                    GestureDetector(
                      onTap: () async {
                        final sign = _sign.currentState;
                        final image = await sign!.getData();
                        var data = await image.toByteData(
                            format: ui.ImageByteFormat.png);
                        sign.clear();

                        String signatureData = base64Encode(
                            Uint8List.sublistView(data!.buffer.asUint8List()));

                        // 서명 데이터를 로컬 DB에 저장
                        SignatureDatabase signatureDB = SignatureDatabase();
                        await signatureDB.initializeDatabase();
                        await signatureDB.insertSignature(signatureData);

                        setState(() {
                          _img = data;
                          hasSignature = true;
                        });
                        try {
                          // 서명 Firebase에 저장
                          Reference ref = FirebaseStorage.instance
                              .ref()
                              .child("서명/$UID.png");

                          UploadTask uploadTask = ref.putData(data.buffer.asUint8List());

                          TaskSnapshot taskSnapshot = await uploadTask;

                          String imageUrl = await taskSnapshot.ref.getDownloadURL();

                          isSignatureRegistered = true;

                          Get.snackbar('title', 'message',
                            backgroundColor: Colors.green,
                            snackPosition: SnackPosition.BOTTOM,
                            titleText: Text("저장 성공", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            messageText: Text("서명을 저장하였습니다.", style: TextStyle(color: Colors.white)),
                          );
                        } catch (e) {
                          print(e);
                          Get.snackbar('title', 'message',
                            backgroundColor: Colors.redAccent,
                            snackPosition: SnackPosition.BOTTOM,
                            titleText: Text("저장 실패", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            messageText: Text("$e", style: TextStyle(color: Colors.white)),
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
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "저장",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        final sign = _sign.currentState;
                        if (sign != null) {
                          sign.clear();
                        } else {
                          // sign 객체가 null인 경우에 대한 처리
                          debugPrint("sign is null");
                        }
                        setState(() {
                          _img = ByteData(0);
                          hasSignature = false;
                        });
                        debugPrint("cleared");
                      },
                      child: Container(
                        width: w * 0.5,
                        height: h * 0.07,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage("img/btn.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "수정",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
