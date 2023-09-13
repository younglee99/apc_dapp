import 'package:agricultural_products/producer/product.dart';
import 'package:agricultural_products/producer/resister.dart';
import 'package:agricultural_products/sign.dart';
import 'package:flutter/material.dart';
import 'package:http/src/client.dart';
import 'package:web3dart/web3dart.dart';
import '../contract.dart';
import 'package:image_picker/image_picker.dart';
import '../variable.dart';
import '../firebase.dart';
import '../gridview.dart';
import 'package:agricultural_products/qr_code.dart';

class ProducerProfile extends StatefulWidget {
  const ProducerProfile({super.key});

  @override
  State<ProducerProfile> createState() => _ProducerProfileState();
}

class _ProducerProfileState extends State<ProducerProfile> {
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
    await getData();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30),
            color: const Color.fromARGB(255, 245, 245, 245),
            height: 130,
            child: Row(children: [
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  "홍길동 님",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
              ),
              const SizedBox(
                width: 130,
              ),
              const Text(
                "생산자",
                style: TextStyle(fontSize: 20),
              ),
            ]),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 117, 185, 148),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 200,
                        height: 50,
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: const Text(
                          "상품 등록 내역",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // 로딩 중인 경우 로딩 화면 표시
                        : SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: imageDates.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 20, right: 20, bottom: 20),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageGridViewPage(
                                              productTitle:
                                                  productTitles[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(children: [
                                        Expanded(
                                            child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10))),
                                          padding: const EdgeInsets.only(
                                              left: 10, top: 15),
                                          width: double.infinity,
                                          height: double.infinity,
                                          child: Text(
                                            "상품 이름 : ${productTitles[index]}",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            textAlign: TextAlign.left,
                                          ),
                                        )),
                                        Expanded(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 15, right: 15),
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: Text(
                                                "업데이트 날짜 : ${imageDates[index]}",
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
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 55,
                width: 322,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 84, 160, 86),
                    foregroundColor: const Color.fromARGB(255, 41, 41, 41),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageUpload(
                                  updateFunction: updateDate,
                                  updateLoading: updateLoadingStatus,
                                )));
                  },
                  child: const Text("상품 등록 +",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 145, 226, 148),
                    foregroundColor: const Color.fromARGB(255, 9, 85, 53),
                    shadowColor: const Color.fromARGB(255, 153, 214, 155),
                    elevation: 10,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProductList()),
                    );
                  },
                  child: const Text("인증서",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 145, 226, 148),
                    foregroundColor: const Color.fromARGB(255, 9, 85, 53),
                    shadowColor: const Color.fromARGB(255, 153, 214, 155),
                    elevation: 10,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignaturePadScreen()));
                  },
                  child: const Text("서명",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝으로 정렬
            children: [
              RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const QRScreen()));
                },
                child: const Icon(
                  Icons.qr_code,
                  size: 35.0,
                ),
              ),
              RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                onPressed: () {},
                child: const Icon(
                  Icons.question_mark,
                  size: 35.0,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
