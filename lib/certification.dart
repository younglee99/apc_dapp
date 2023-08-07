import 'package:agricultural_products/con_product.dart';

import 'package:flutter/material.dart';

class Certification extends StatelessWidget {
  const Certification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 330,
          height: 610,
          margin: const EdgeInsets.only(top: 25),
          decoration: BoxDecoration(
              border: Border.all(), borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Container(
                height: 30,
                width: 300,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "인증번호 : 1호",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Container(
                height: 70,
                width: 250,
                padding: const EdgeInsets.only(top: 20),
                child: const Text(
                  "농산물 블록체인 인증서",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  height: 30,
                  width: 280,
                  alignment: Alignment.centerRight,
                  child: const Text("<생산자>",
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300))),
              SizedBox(
                height: 300,
                width: 280,
                child: Column(children: [
                  const Divider(
                    color: Colors.black54,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text("생산자 : 홍길동"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text("사업자 등록번호 : 000"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text("주소 : 어딘가"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: const Text("농장 소재지 : 어딘가"),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text("인증 품목 : "),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ConsumerProduct(),
                                  ),
                                );
                              },
                              child: const Text("목록보기"))
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.black54,
                  ),
                ]),
              ),
              Container(
                height: 50,
                width: 300,
                margin: const EdgeInsets.only(top: 20),
                padding: const EdgeInsets.only(left: 10),
                child: const Text(
                  "위 인증서는 블록체인에 등록된 인증서로   신뢰성을 보장합니다.",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Container(
                height: 50,
                width: 280,
                alignment: Alignment.centerRight,
                child: const Text(
                  "2023년 7월 12일",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w200),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
