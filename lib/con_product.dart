import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'variable.dart';
import 'gridview.dart';

class ConsumerProduct extends StatefulWidget {
  const ConsumerProduct({super.key});

  @override
  State<ConsumerProduct> createState() => MainScreenState();
}

class MainScreenState extends State<ConsumerProduct> {
  List<XFile?> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 30),
            height: 90,
            child: Row(children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              Container(
                margin: const EdgeInsets.only(left: 90),
                child: const Text(
                  "인증 품목",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ]),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
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
                          "제품 등록 내역",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: dataList.length,
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
                                      builder: (context) => ImageGridViewPage(
                                        productTitle: dataList[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Column(children: [
                                  Expanded(
                                      child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 15),
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Text(
                                      "상품 이름 : ${dataList[index]}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.left,
                                    ),
                                  )),
                                ])),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
