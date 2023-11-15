import 'package:flutter/material.dart';
import 'package:trust_blockchain/certification.dart';
import 'package:trust_blockchain/database.dart';
import 'package:trust_blockchain/global_variable.dart';

class Distribution_to_Consumers extends StatefulWidget {
  const Distribution_to_Consumers({super.key});

  @override
  State<Distribution_to_Consumers> createState() => _Distribution_to_ConsumersState();
}

class _Distribution_to_ConsumersState extends State<Distribution_to_Consumers> {
  late int noteCount;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateDate();
  }

  Future<void> updateDate() async {
    await collectFarmNamesAndDates(distributorUIDList);
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
          leading: IconButton(
            onPressed: () {Navigator.pop(context, 'update');},
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Color(0xFF256B66), elevation: 0),
      body: Stack(
        children: [
          // 배경사진
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
                      "농장 목록",
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
                              itemCount: distributorUIDList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 20, right: 20, bottom: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Certification(farmUID: distributorUIDList[index]),),);
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
                                                "농장 이름 : ${distributorNameList[index]}",
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
                                                "등록 날짜 : ${distributorDateList[index]}",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500),
                                                textAlign: TextAlign.right),
                                          ),
                                        )
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
