import 'package:flutter/material.dart';
import 'package:trust_blockchain/database.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/contract.dart';

class Distribution_to_Distributors extends StatefulWidget {
  const Distribution_to_Distributors({super.key});

  @override
  State<Distribution_to_Distributors> createState() => _Distribution_to_DistributorsState();
}

class _Distribution_to_DistributorsState extends State<Distribution_to_Distributors> {
  late int noteCount;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    updateDate();
    dataList = [];
    dataUrlList = [];
    testList = [];
  }

  Future<void> updateDate() async {
    await getNoteById();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getNoteById() async {
    final List<dynamic> result = await ethClient.call(
      contract: contract,
      function: getNoteCountFunction,
      params: [producerUID],
    );

    noteCount = result[0].toInt();
    print(noteCount);

    for (int i = 0; i < noteCount; i++) {
      final List<dynamic> noteResult = await ethClient.call(
        contract: contract,
        function: getNoteByIdFunction,
        params: [producerUID, BigInt.from(i)],
      );
      setState(() {
        dataList.add(noteResult[0].toString());
        testList.add(noteResult[1].toString());
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
          backgroundColor: Color(0xFF256B66),
          elevation: 0),
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
                      "생산 품목",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.02,),
                  Container(
                    height: h * 0.69,
                    child: isLoading
                        ? const Center(
                            child:
                                CircularProgressIndicator()) // 로딩 중인 경우 로딩 화면 표시
                        : SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: dataList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  height: 80,
                                  margin: const EdgeInsets.only(
                                      top: 0, left: 20, right: 20, bottom: 10),
                                  child: GestureDetector(
                                      onTap: () {
                                        dataUrlList = testList[index].split(',');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ImageView(dataList[index]),),
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
                  // 농장 저장 버튼
                  GestureDetector(
                    onTap: () async {
                      try {
                        String? farmName = await getFarmName(producerUID); // await로 결과 대기
                        if (farmName != null) {
                          String UID = producerUID; // 사용자 UID
                          // 농장 DB에 저장
                          await ProducerUIDDatabase().insertFarm(farmName, UID);
                          Navigator.pop(context, 'update');
                        } else {
                          // farmName이 null인 경우에 대한 처리
                          print("농장 이름을 찾을 수 없습니다.");
                        }
                      } catch (e) {
                        print("ERROR : $e");
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
                          child: const Text("농장 저장",
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
    );
  }
}

// 이미지 출력
class ImageView extends StatelessWidget {
  final String message;

  const ImageView(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text("$message"),
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
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(10),
              itemCount: dataUrlList.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  width: 250,
                  height: 400,
                  child: Image.network(
                    dataUrlList[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ));
  }
}
