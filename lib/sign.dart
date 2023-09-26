import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:convert';
import 'sign_data.dart';

class SignaturePadScreen extends StatefulWidget {
  const SignaturePadScreen({super.key});

  @override
  State<SignaturePadScreen> createState() => _SignaturePadScreenState();
}

class _SignaturePadScreenState extends State<SignaturePadScreen> {
  final GlobalKey<SignatureState> _sign = GlobalKey();
  ByteData _img = ByteData(0);
  double strokeWidth = 5.0;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('서명'),
      ),
      body: Column(
        children: [
          if (hasSignature)
            Expanded(
              child: Center(
                child: Image.memory(_img.buffer.asUint8List()),
              ),
            )
          else
            Expanded(
              child: Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Signature(
                    color: Colors.black,
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
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (!hasSignature)
                MaterialButton(
                  color: Colors.green,
                  onPressed: () async {
                    final sign = _sign.currentState;
                    final image = await sign!.getData();
                    var data =
                        await image.toByteData(format: ui.ImageByteFormat.png);
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

                    debugPrint("onPressed");
                  },
                  child: const Text("저장"),
                )
              else
                MaterialButton(
                  color: Colors.grey,
                  onPressed: () {
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
                  child: const Text("수정"),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
