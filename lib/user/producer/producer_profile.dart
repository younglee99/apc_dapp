import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/web3dart.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import 'package:trust_blockchain/contract.dart';
import 'package:trust_blockchain/database.dart';
import 'package:trust_blockchain/gridview.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/sign.dart';
import 'package:trust_blockchain/user/producer/image_upload.dart';

class ProducerProfile extends StatefulWidget {
  const ProducerProfile({super.key});

  @override
  State<ProducerProfile> createState() => _ProducerProfileState();
}

class _ProducerProfileState extends State<ProducerProfile> {
  FirebaseStorage storage = FirebaseStorage.instance;
  String UID = userUID;
  String client = Eth_Client;
  List<XFile?> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateDate();
    connectToEthereum();
    httpClient = Client();
    ethClient = Web3Client(client, httpClient);
  }

  void updateLoadingStatus(bool newStatus) {
    setState(() {
      isLoading = newStatus;
    });
  }

  Future<void> updateDate() async {
    await getData();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteProduct(int index) async {
    String getCurrentDateTime() {
      var now = DateTime.now();
      var formatter = DateFormat('yyyy년 MM월 dd일 HH시 mm분 ss초');
      String formatted = formatter.format(now);
      return formatted;
    }
    String changeProductTitle = '${productTitleList[index]}(삭제됨)';
    String changeProductContent = getCurrentDateTime()+'\n$userName에 의해 삭제되었습니다.';
    print(changeProductTitle+'\n'+changeProductContent);
    // 파이어베이스 저장소에서 이미지 참조를 가져옵니다.
    Reference ref = storage.ref().child('$UID/${productTitleList[index]}/');

    try {
      // 제품 폴더 내의 모든 파일의 목록을 가져옵니다.
      ListResult result = await ref.listAll();
      for (var item in result.items) {
        await item.delete();
      }
      print('Firebase Storage에서 제거 완료');

      // updateNoteByIndex(userUID, index, changeProductTitle, changeProductContent);
      productTitleList.removeAt(index);
      updateDateList.removeAt(index);
      print('리스트에 상품 제거 완료');
      updateDate();

      Get.snackbar("About User", "User message",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("제거 완료", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("해당 상품을 제거하였습니다.", style: TextStyle(color: Colors.white,)),
      );

    } catch (e) {
      print('Failed to delete product folder: $e');
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
                            "상품 등록 내역",
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
                              itemCount: updateDateList.length,
                              itemBuilder:
                                  (BuildContext context, int index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                          MaterialPageRoute(
                                            builder: (context) => ImageGridViewPage(productTitle: productTitleList[index], farmUID: '',),
                                          ),
                                        );
                                      },
                                      onLongPress: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('상품 삭제'),
                                              content: Text(productTitleList[index]+' 상품을 목록에서 제거하시겠습니까?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {Navigator.of(context).pop();},
                                                  child: Text("취소"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.of(context).pop();
                                                    await deleteProduct(index);
                                                    setState(() {});
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
                                                "상품 이름 : ${productTitleList[index]}",
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
                                                "업데이트 날짜 : ${updateDateList[index]}",
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
                        // 상품 등록 버튼
                        GestureDetector(
                          onTap: () {
                            if (isSignatureRegistered) {
                              // 서명이 등록되어 있다면, 이미지 업로드 화면으로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageUpload(
                                    updateFunction: updateDate,
                                    updateLoading: updateLoadingStatus,
                                  ),
                                ),
                              );
                            } else {
                              // 서명이 등록되어 있지 않다면, 경고 메시지를 표시
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('알림'),
                                    content: Text('등록하기 위해 서명이 필요합니다.\n서명을 등록해주세요.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('등록'),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => SignaturePadScreen())
                                          );
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
                                child: const Text("상품 등록 +",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700)),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

