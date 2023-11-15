import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/user/consumer/distribution_to_con.dart';
import 'package:trust_blockchain/user/distributor/distribution_to_dist.dart';

class QRcodeScanScreen extends StatelessWidget {
  const QRcodeScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: QRScannerPage());
  }
}

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  // 이전에 스캔한 시간과 현재 스캔한 시간의 차이를 저장하기 위한 변수
  DateTime? lastScanTime;

  // 이전에 스캔한 문자열과 현재 스캔한 문자열의 비교를 위한 변수
  String? lastScannedData;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  bool checking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQRView(),
          isScanning
              ? const Text(
            "QR코드를 인식하세요",
            style: TextStyle(color: Colors.white, fontSize: 25),
          )
              : checking
              ? buildScanIndicator()
              : const Text(
            "잘못된 QR코드 입니다",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ],
      ),
    );
  }

  Widget buildQRView() {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
    );
  }

  Widget buildScanIndicator() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      bottom: 20.0,
      child: Container(
          width: w * 0.3,
          height: h * 0.07,
          decoration: const BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: TextButton(
              onPressed: () async {
                if(userClassification == '유통업자'){
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Distribution_to_Distributors()));
                  if (result == 'update') {
                    Navigator.pop(context, 'update');
                  }
                } else {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => Distribution_to_Consumers()));
                  if (result == 'update') {
                    Navigator.pop(context, 'update');
                  }
                }
              },
              child: Text("확인",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
              ))),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isScanning && !_isInCooldown(scanData.code)) {
        setState(() {
          isScanning = false;
        });

        String? scannedData = scanData.code;
        if (scannedData == null) {
        }
        // 생산자 -> 유통업자
        else if (scannedData.substring(0, 4) == "1111") {
          setState(() {
            checking = true;
          });
          // 스캔된 문자열을 분해하여 원래의 리스트 형태로 되돌림
          scannedData = scannedData.substring(4);
          // 분해한 데이터를 리스트에 넣음
          setState(() {
            producerUID = scannedData!;
            print(producerUID);
          });
        }
        // 유통업자 -> 소비자
        else if(scannedData.substring(0, 4) == "2222"){
          setState(() {
            checking = true;
          });
          String scannedListData = scannedData.substring(4);

          // JSON 형식의 문자열을 다시 List<dynamic>으로 변환
          List<dynamic> decodedData = jsonDecode(scannedListData);

          setState(() {
            // List<dynamic>을 List<String?>으로 변환
            distributorUIDList = decodedData.cast<String?>();
            print(distributorUIDList);
          });
        }
        // 그외
        else {
          setState(() {
            checking = false;
          });
        }

        // 스캔 인터벌을 주기 위해 2초 대기 후 다시 스캔 가능하게 설정
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isScanning = true;
          });
        });
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {});
        });
      }
    });
  }

  // 스캔 인터벌을 체크하는 메서드
  bool _isInCooldown(String? scannedData) {
    final currentTime = DateTime.now();
    if (lastScanTime == null || lastScannedData != scannedData) {
      lastScanTime = currentTime;
      lastScannedData = scannedData;
      return false;
    }

    final timeDifference = currentTime.difference(lastScanTime!);
    if (timeDifference.inMilliseconds < 1000) {
      return true; // 스캔 인터벌이 2초 미만이면 무시
    }

    lastScanTime = currentTime;
    lastScannedData = scannedData;
    return false;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
