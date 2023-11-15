import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/database.dart';
import 'package:trust_blockchain/gridview.dart';

class ProductsList extends StatefulWidget {
  final String? farmName;
  final String? farmUID;

  ProductsList({super.key, required this.farmName, required this.farmUID});

  @override
  State<ProductsList> createState() => MainScreenState();
}

class MainScreenState extends State<ProductsList> {
  List<XFile?> images = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateDate();
  }

  Future<void> updateDate() async {
    await getFarmData(widget.farmUID);
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
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text("${widget.farmName}"),
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
          Center(
            child: Container(
              width: w * 0.9,
              height: h * 0.85,
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
                    height: h * 0.73,
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // 로딩 중인 경우 로딩 화면 표시
                        : SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: updateDateList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 20, right: 20, bottom: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageGridViewPage(productTitle: productTitleList[index], farmUID: widget.farmUID,
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
                                            "상품 이름 : ${productTitleList[index]}",
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
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
