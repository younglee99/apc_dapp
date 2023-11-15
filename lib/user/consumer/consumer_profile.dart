import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:trust_blockchain/page/qr_code_screen/qr_code_scan_screen.dart';
import 'package:web3dart/web3dart.dart';

import 'package:trust_blockchain/certification.dart';
import 'package:trust_blockchain/contract.dart';
import 'package:trust_blockchain/database.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/sign.dart';

class ConsumerProfile extends StatefulWidget {
  const ConsumerProfile({super.key});

  @override
  State<ConsumerProfile> createState() => _ConsumerProfileState();
}

class _ConsumerProfileState extends State<ConsumerProfile> {
  List<XFile?> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateDate();
    connectToEthereum();
    httpClient = Client();
    ethClient = Web3Client(
        "https://sepolia.infura.io/v3/d834909dd4f0443590207949eef1e469",
        httpClient);
  }

  void updateLoadingStatus(bool newStatus) {
    setState(() {
      isLoading = newStatus;
    });
  }

  Future<void> updateDate() async {
    await getFarmDataFromDatabase();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              updateDate();
              setState(() {});
            }, icon: Icon(Icons.refresh))
          ],
          title: Container(
              child: Row(
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 30,
                    ),
                  ),
                  Text(
                    "  님 반갑습니다!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              )),
          backgroundColor: Color(0xFF256B66),
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
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: w * 0.9,
                    height: h * 0.8,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 117, 185, 148),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: w,
                          height: h * 0.07,
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: const Text(
                            "저장한 농장",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: h * 0.02,
                        ),
                        Container(
                          height: h * 0.64,
                          child: isLoading
                              ? Center(child: CircularProgressIndicator()) // 로딩 중인 경우 로딩 화면 표시
                              : SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: farmUIDList.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(
                                      top: 0,
                                      left: 20,
                                      right: 20,
                                      bottom: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Certification(farmUID: farmUIDList[index]),
                                          ),
                                        );
                                      },
                                      onLongPress: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("농장 삭제"),
                                              content: Text(farmNameList[index]+"을 삭제하시겠습니까?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("취소"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    // 해당 농장 삭제
                                                    await DistributorUIDDatabase().deleteFarm(farmUIDList[index]!);
                                                    updateDate();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("확인"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Column(children: [
                                        Expanded(
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      topLeft:
                                                      Radius.circular(
                                                          10),
                                                      topRight:
                                                      Radius.circular(
                                                          10))),
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 15),
                                              width: double.infinity,
                                              height: double.infinity,
                                              child: Text(
                                                "농장 이름 : ${farmNameList[index]}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight.w500),
                                                textAlign: TextAlign.left,
                                              ),
                                            )),
                                        Expanded(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.only(
                                                    bottomLeft: Radius
                                                        .circular(10),
                                                    bottomRight:
                                                    Radius.circular(
                                                        10))),
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                top: 15,
                                                right: 15),
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                                "저장 날짜 : ${farmDateList[index]}",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                    FontWeight.w500),
                                                textAlign: TextAlign.right),
                                          ),
                                        )
                                      ])),
                                );
                              },
                            ),
                          ),
                        ),
                        // 농장 등록 버튼
                        GestureDetector(
                          onTap: () async {
                            if (isSignatureRegistered) {
                              // 서명이 등록되어 있다면, 이미지 업로드 화면으로 이동
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const QRcodeScanScreen()),
                              );

                              // 'update' 문자열을 반환받으면 데이터를 새로 고침
                              if (result == 'update') {
                                updateDate();
                                setState(() {});
                              }
                            } else {
                              // 서명이 등록되어 있지 않다면, 경고 메시지를 표시
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('알림'),
                                    content:
                                    Text('등록하기 위해 서명이 필요합니다.\n서명을 등록해주세요.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('등록'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => SignaturePadScreen()));
                                        },
                                      ),
                                      TextButton(
                                        child: Text('닫기'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            width: w * 0.9,
                            height: h * 0.07,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage("img/btn.png"),
                                    fit: BoxFit.cover)),
                              child: Center(
                                child: const Text("농장 등록 +",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700)),
                              )),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
