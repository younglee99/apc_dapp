import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trust_blockchain/user/consumer/con_productsList.dart';
import 'package:trust_blockchain/database.dart';

class Certification extends StatefulWidget {
  final String? farmUID;

  const Certification({Key? key, required this.farmUID}) : super(key: key);

  @override
  _CertificationState createState() => _CertificationState();
}

class _CertificationState extends State<Certification> {
  String? UID;
  String name = '';
  String email = '';
  String phoneNumber = '';
  String classification = '';
  String address = '';
  String businessRegistrationNumber = '';
  String businessName = '';
  String? signatureImageUrl;

  @override
  void initState() {
    super.initState();
    UID = widget.farmUID;
    getProducerData(UID);
    getSignatureUrl(UID!).then((url) => setState(() => signatureImageUrl = url));

  }

  // 생산자 데이터 가져옴
  Future<void> getProducerData(String? farmUID) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot documentSnapshot = await firestore.collection('Producers').doc(UID).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        name = data['name'] ?? '';
        email = data['email']?? '';
        phoneNumber = data['phone'] ?? '';
        classification = data['classification'] ?? '';
        address = data['address'] ?? '';
        businessRegistrationNumber = data['business'] ?? '';
        businessName = data['businessName'] ?? '';
      });
    } else {
      print("해당 농장 없음");
    }
  }

  // 생산자 서명을 가져옴
  Future<String> getSignatureUrl(String UID) async {
    Reference ref = FirebaseStorage.instance.ref().child("서명/$UID.png");

    try {
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return '';
    }
  }


  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('yyyy년 MM월 dd일').format(currentDate);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: Colors.black), // 검정색 아이콘
        ),
        actions: [
          IconButton(
            onPressed: () {
              DistributorUIDDatabase().insertFarm(businessName, UID!);
              Navigator.pop(context, true);
            },
            icon: Icon(Icons.save, color: Colors.black), // 검정색 아이콘
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: h * 0.88,
          width: w * 0.9,
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                height: h * 0.05,
                width: w * 0.8,
                alignment: Alignment.centerLeft,
                child: const Text(
                  "인증번호 : 1호",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              Container(
                height: h * 0.07,
                width: w * 0.8,
                child: const Text(
                  "농산물 블록체인 인증서",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  height: h * 0.03,
                  width: w * 0.8,
                  alignment: Alignment.centerRight,
                  child: Text("<$classification>",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300))),
              Container(
                height: h*0.5,
                width: w * 0.8,
                child: Column(children: [
                  const Divider(
                    color: Colors.black54,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("생산자 : $name"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("상호명 : $businessName"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("사업자 등록번호 : $businessRegistrationNumber"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text("주소 : $address"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text("인증 품목 : "),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ConsumerProductsList(farmUID: UID),
                                  ),
                                );
                              },
                              child: const Text("목록보기"))
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black54,
                  ),
                ]),
              ),
              Container(
                height: h * 0.07,
                width: w * 0.8,
                child: const Text(
                  "위 인증서는 블록체인에 등록된 인증서로   신뢰성을 보장합니다.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Container(
                height: h * 0.05,
                width: w * 0.8,
                alignment: Alignment.centerRight,
                child: Text(
                  formattedDate,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                ),
              ),
              Container(
                height: h * 0.08,
                width: w * 0.8,
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // 오른쪽 정렬
                  children: [
                    Text(
                      "서명 : $name",
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w200),
                    ),
                    if (signatureImageUrl != null && signatureImageUrl!.isNotEmpty)
                      Image.network(signatureImageUrl!, height: 50, width: 50), // 이미지 크기는 조정하세요.
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}