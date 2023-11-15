import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_blockchain/auth_controller.dart';
import 'package:trust_blockchain/page/email_login_page/email_login_page.dart';
import 'package:trust_blockchain/page/signup_page/email_auth_page.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF256B66),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: h * 0.1,),
            Container(
              width: w * 0.8,
              height: h * 0.4,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("img/splash.png"), fit: BoxFit.contain)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "농산물 인증 시스템",
                    style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: h * 0.1,),
                ],
              ),
            ),
            // 구글 버튼
            GestureDetector(
              onTap: (){
                AuthController.instance.googleSignIn();
              },
              child: Container(
                  width: w * 0.9,
                  height: h * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage("img/google.png"),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Text(
                      "Google로 시작하기",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  )),
            ),
            SizedBox(height: 10,),
            // 카카오 버튼
            GestureDetector(
              onTap: () {
                AuthController.instance.kakaoSignIn();
              },
              child: Container(
                  width: w * 0.9,
                  height: h * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage("img/kakao.png"),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Text(
                      "카카오로 시작하기",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  )),
            ),
            SizedBox(height: 10,),
            // 가입 버튼
            GestureDetector(
              onTap: (){
                Get.to(()=>EmailAuthPage());
              },
              child: Container(
                  width: w * 0.9,
                  height: h * 0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage("img/btn.png"),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Text(
                      "가입하기",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ),
            SizedBox(height: 15,),
            RichText(
                text: TextSpan(
                    text: "이미 계정이 있으신가요?  ",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                    ),
                    children: [
                  TextSpan(
                    text: "로그인",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                    ),
                    recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>EmailLoginPage())
                  )
                ])),
          ],
        ),
      ),
    );
  }
}
