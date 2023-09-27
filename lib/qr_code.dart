import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'variable.dart';
import 'sign_data.dart';
import 'dart:convert';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  List<String> qrListData = [];
  String qrData = "";
  bool isLoading_ = true;

  @override
  void initState() {
    super.initState();
    updateData();
  }

  Future<void> updateData() async {
    SignatureDatabase signatureDB = SignatureDatabase();
    await signatureDB.initializeDatabase();
    List<String> signatures = await signatureDB.getAllSignatures();
    String lastSignature = signatures.last;
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!object");
    print(lastSignature);

    Map<String, dynamic> jsonData = {
      'password': '1111',
      'uid': uid,
      'sign': "lastSie",
    };

    if (mounted) {
      setState(() {
        qrData = jsonEncode(jsonData);
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!object");
        print(qrData);
        isLoading_ = false;
      });
    }
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
