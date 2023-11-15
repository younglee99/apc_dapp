import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_blockchain/auth_controller.dart';
import 'package:trust_blockchain/page/signup_page/phone_auth_page.dart';
import 'package:email_validator/email_validator.dart';

class EmailAuthPage extends StatefulWidget {
  const EmailAuthPage({Key? key}) : super(key: key);

  @override
  State<EmailAuthPage> createState() => _EmailAuthPageState();
}

class _EmailAuthPageState extends State<EmailAuthPage> {
  bool passwordMatch = true;
  bool emailValid = true;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var onfirmPasswordController = TextEditingController();

  bool _isAllFieldsFilled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        onfirmPasswordController.text.isNotEmpty;
  }

  void _checkPasswordMatch() {
    setState(() {
      final password = passwordController.text;
      final confirmPassword = onfirmPasswordController.text;
      passwordMatch = password == confirmPassword && password.length >= 6;
    });
  }

  void _checkEmailValid() {
    setState(() {
      emailValid = EmailValidator.validate(emailController.text);
    });
  }

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
                  Text("이메일 가입", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
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
                        onChanged: (_) => _checkEmailValid(),
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
                          hintText: "이메일",
                          prefixIcon: Icon(Icons.email, color: Colors.lightGreen,),
                            errorText: !emailValid
                                ? '     유효한 이메일 형식으로 입력해주세요.'
                                : null
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
                        onChanged: (_) => _checkPasswordMatch(),
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
                        controller: onfirmPasswordController,
                        obscureText: true,
                        onChanged: (_) => _checkPasswordMatch(),
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
                          hintText: "비밀번호 확인",
                          prefixIcon: Icon(Icons.check_box_outlined, color: Colors.lightGreen,),
                          errorText: !passwordMatch
                              ? '      비밀번호가 일치하지 않거나, 6자 이상이어야 합니다.'
                              : null,
                        )),
                  ),
                  SizedBox(height: h*0.1),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: () async {
                if (_isAllFieldsFilled() && passwordMatch && emailValid) {
                  showLoadingIndicator(context);
                  bool registrationSuccessful = await AuthController.instance.emailRegister(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  Navigator.of(context).pop();
                  if (registrationSuccessful) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneAuthPage(
                          email: emailController.text.trim(),
                        ),
                      ),
                    );
                  }
                }
                if (!_isAllFieldsFilled()) {
                  Get.snackbar("Title", "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("계정 생성 실패",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("빈칸을 모두 입력하세요.",
                        style: TextStyle(color: Colors.white)),
                  );
                  return;
                }
                if(!emailValid){
                  Get.snackbar("Title", "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("계정 생성 실패",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("이메일을 올바르게 입력하세요.",
                        style: TextStyle(color: Colors.white)),
                  );
                  return;
                }
                if(!passwordMatch){
                  Get.snackbar("Title", "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("계정 생성 실패",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("비밀번호를 확인하세요.",
                        style: TextStyle(color: Colors.white)),
                  );
                  return;
                }
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
                      "다음",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
