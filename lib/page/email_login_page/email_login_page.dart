import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_blockchain/auth_controller.dart';
import 'package:trust_blockchain/page/email_login_page/reset_password_page.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({Key? key}) : super(key: key);

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

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
                      image: AssetImage("img/background.png"), fit: BoxFit.cover)),
            ),
            // 정보 입력
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("로그인", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                  Text("이메일과 비밀번호를 입력하세요.", style: TextStyle(fontSize: 15, color: Colors.grey[500]),),
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
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "이메일",
                          prefixIcon: Icon(Icons.email, color: Colors.lightGreen,),
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
                        )),
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
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "비밀번호",
                          prefixIcon: Icon(Icons.lock, color: Colors.lightGreen,),
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
                        )),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      RichText(
                          text: TextSpan(
                              recognizer: TapGestureRecognizer()..onTap = () => Get.to(()=>ResetPasswordPage()),
                              text: "비밀번호를 잊으셨나요?",
                              style: TextStyle(fontSize: 15, color: Colors.grey[500]))
                      ),
                    ],
                  ),
                  SizedBox(height: h*0.1),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: (){
                AuthController.instance.signIn(
                    emailController.text.trim(),
                    passwordController.text.trim()
                );
              },
              child: Container(
                  width: w * 0.5,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: AssetImage("img/btn.png"),
                          fit: BoxFit.cover)),
                  child: Center(
                    child: Text(
                      "로그인",
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
