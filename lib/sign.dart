import 'package:flutter/material.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class SignaturePadScreen extends StatefulWidget {
  const SignaturePadScreen({super.key});

  @override
  State<SignaturePadScreen> createState() => _SignaturePadScreenState();
}

class _SignaturePadScreenState extends State<SignaturePadScreen> {
  final GlobalKey<SignatureState> _sign = GlobalKey();
  ByteData _img = ByteData(0);
  double strokeWidth = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('                  서명'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              '서명해주세요',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.black12,
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
          ),
          _img.buffer.lengthInBytes == 0
              ? Container()
              : LimitedBox(
                  maxHeight: 200.0,
                  child: Image.memory(_img.buffer.asUint8List()),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: () async {
                  final sign = _sign.currentState;
                  final image = await sign!.getData();
                  var data =
                      await image.toByteData(format: ui.ImageByteFormat.png);
                  sign.clear();
                  setState(() {
                    _img = data!;
                  });
                  debugPrint("onPressed");
                },
                child: const Text("Save"),
              ),
              MaterialButton(
                color: Colors.grey,
                onPressed: () {
                  final sign = _sign.currentState;
                  sign!.clear();
                  setState(() {
                    _img = ByteData(0);
                  });
                  debugPrint("cleared");
                },
                child: const Text("Clear"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
