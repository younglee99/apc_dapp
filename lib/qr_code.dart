import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'variable.dart';
import 'firebase.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({Key? key}) : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  List<String> qrListData = [];
  String qrData = "";
  bool isLoading_ = true; // isLoading_ 상태 변수 추가

  @override
  void initState() {
    super.initState();
    updateDate();
  }

  Future<void> updateDate() async {
    await getData();
    if (mounted) {
      setState(() {
        qrData = "1111$uid";
        isLoading_ = false; // 데이터 업데이트가 완료되면 isLoading_ 상태를 false로 변경
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
