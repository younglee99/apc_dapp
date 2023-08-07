import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../variable.dart';
import '../firebase.dart';
import '../gridview.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => MainScreenState();
}

class MainScreenState extends State<ProductList> {
  List<XFile?> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateDate();
  }

  Future<void> updateDate() async {
    await getData();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void handleImagesSelected(List<XFile?> selectedImages) {
    setState(() {
      images = selectedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2,
        title: const Text("            상품 내역",
            style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
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
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
