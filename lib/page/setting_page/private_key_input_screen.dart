import 'package:flutter/material.dart';
import 'package:trust_blockchain/auth_controller.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:url_launcher/url_launcher.dart';


class PrivateKeyInputScreen extends StatefulWidget {
  const PrivateKeyInputScreen({Key? key}) : super(key: key);

  @override
  State<PrivateKeyInputScreen> createState() => _PrivateKeyInputScreenState();
}

class _PrivateKeyInputScreenState extends State<PrivateKeyInputScreen> {
  var privateKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xFF256B66),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 이미지
            Container(
              width: w,
              height: h * 0.2,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/background.png"),
                      fit: BoxFit.cover)),
            ),
            // 정보 입력
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "개인 키 입력",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "블록체인을 사용하기 위해서는 개인 키가 필요합니다.\nMetaMask에 가입을 하여 개인 키를 입력해 주세요.",
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                  SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      // URL을 설정
                      String url = 'https://metaextentions.com';  // 원하는 URL로 변경

                      // URL을 열기 위해 url_launcher 패키지 사용
                      launch(url).catchError((err) {
                        print('Error launching URL: $err');
                      });
                    },
                    child: Text("MetaMask로 이동"),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      // minimumSize: MaterialStateProperty.all(Size(40, 62)),
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1, 1),
                              color: Colors.grey.withOpacity(0.2))
                        ]),
                    child: TextField(
                        controller: privateKeyController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          hintText: "개인 키",
                          prefixIcon: Icon(
                            Icons.key,
                            color: Colors.lightGreen,
                          ),
                        )),
                  ),
                  SizedBox(height: h * 0.1),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: () async {
                String PrivateKey = privateKeyController.text.trim();
                if(PrivateKey.isNotEmpty){
                  AuthController.instance.privateKeySave(PrivateKey, userUID);
                }
              },
              child: Container(
                  width: w * 0.5,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage("img/btn.png"), fit: BoxFit.cover)),
                  child: Center(
                    child: Text(
                      "저장",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
