import 'package:agricultural_products/variable.dart';
import 'contract.dart';
import 'package:flutter/material.dart';

class Distribution extends StatefulWidget {
  const Distribution({super.key});

  @override
  State<Distribution> createState() => _DistributionState();
}

class _DistributionState extends State<Distribution> {
  late int noteCount;

  @override
  void initState() {
    super.initState();
    getNoteById();
  }

  Future<void> getNoteById() async {
    final List<dynamic> result = await ethClient.call(
      contract: contract,
      function: getNoteCountFunction,
      params: [productUID],
    );

    noteCount = result[0].toInt();
    print(noteCount);

    for (int i = 0; i < noteCount; i++) {
      final List<dynamic> noteResult = await ethClient.call(
        contract: contract,
        function: getNoteByIdFunction,
        params: [productUID, BigInt.from(i)],
      );
      setState(() {
        dataList.add(noteResult[0].toString());
        testList.add(noteResult[1].toString());
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
                  "유통 품목",
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
                          "유통 상품 내역",
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
                                  dataUrlList = testList[index].split(',');
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
    return Scaffold(
      appBar: AppBar(
        title: Text("                  $message"),
      ),
      body: ListView.builder(
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
    );
  }
}
