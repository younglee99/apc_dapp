import 'package:agricultural_products/producer/product.dart';
import 'package:agricultural_products/producer/resister.dart';
import 'package:agricultural_products/signresister.dart';
import 'package:flutter/material.dart';

class ProducerProfile extends StatefulWidget {
  const ProducerProfile({super.key});

  @override
  State<ProducerProfile> createState() => _ProducerProfileState();
}

class _ProducerProfileState extends State<ProducerProfile> {
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
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 250,
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
                  child: const Text("상품내역",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
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
                height: 70,
                width: 250,
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
                  child: const Text("유통내역",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
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
                height: 70,
                width: 250,
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
                            builder: (context) => const ImageUpload()));
                  },
                  child: const Text("상품 등록",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
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
                height: 70,
                width: 250,
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
                  child: const Text("유통",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
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
                width: 130,
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
                width: 10,
              ),
              SizedBox(
                height: 50,
                width: 130,
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
                            builder: (context) => const SignResister()));
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
          Align(
              alignment: Alignment.centerRight,
              child: RawMaterialButton(
                elevation: 2.0,
                fillColor: Colors.white,
                padding: const EdgeInsets.all(15.0),
                shape: const CircleBorder(),
                onPressed: () {},
                child: const Icon(
                  Icons.question_mark,
                  size: 35.0,
                ),
              ))
        ],
      ),
    );
  }
}
