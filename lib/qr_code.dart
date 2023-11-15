import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/database.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String qrData = "";
  bool isLoading_ = true; // isLoading_ 상태 변수 추가

  @override
  void initState() {
    super.initState();
    if(userClassification == '생산자'){
      producerQRBuilder();
    } else if(userClassification == '유통업자'){
      distributorQRBuilder();
    } else {

    }
  }

  Future<void> producerQRBuilder() async {
    qrData = "1111$userUID";
    isLoading_ = false;
  }

  Future<void> distributorQRBuilder() async {
    String farmData = jsonEncode(farmUIDList);
    // String userData = jsonEncode(userUID);
    print("농장 UID : $farmData");
    qrData = "2222$farmData";
    isLoading_ = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading_ // isLoading_ 상태에 따라 QR 코드를 표시하거나 숨김
            ? const CircularProgressIndicator() // 로딩 중이면 로딩 인디케이터 표시
            : SizedBox(
                width: 200.0,
                height: 200.0,
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
      ),
    );
  }
}
