import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../global_variable.dart';
import 'package:trust_blockchain/contract.dart';

class ConsumerProductsList extends StatefulWidget {
  final String? farmUID;
  const ConsumerProductsList({Key? key, required this.farmUID}) : super(key: key);

  @override
  State<ConsumerProductsList> createState() => MainScreenState();
}

class MainScreenState extends State<ConsumerProductsList> {
  String? UID;
  List<XFile?> images = [];
  bool isLoading = true;
  late int noteCount;

  @override
  void initState() {
    super.initState();
    UID = widget.farmUID;
    dataList = [];
    dataUrlList = [];
    testList = [];
    updateDate();
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
      params: [UID],
    );

    noteCount = result[0].toInt();
    print(noteCount);

    for (int i = 0; i < noteCount; i++) {
      final List<dynamic> noteResult = await ethClient.call(
        contract: contract,
        function: getNoteByIdFunction,
        params: [UID, BigInt.from(i)],
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
                        itemCount: dataList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 80,
                            margin: const EdgeInsets.only(
                                top: 0, left: 20, right: 20, bottom: 10),
                            child: GestureDetector(
                                onTap: () {
                                  dataUrlList =
                                      testList[index].split(',');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ImageView(dataList[index]),
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