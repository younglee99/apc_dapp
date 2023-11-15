import 'package:flutter/material.dart';
import 'package:trust_blockchain/auth_controller.dart';

class ResetPasswordPage extends StatelessWidget {
  ResetPasswordPage({Key? key}) : super(key: key);
  var resetemailController = TextEditingController();

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
                  Text("비밀번호 재설정", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                  Text("다시 계정에 로그인할 수 있는 링크를 보내드립니다.", style: TextStyle(fontSize: 15, color: Colors.grey[500]),),
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
                        controller: resetemailController,
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
                  SizedBox(height: h*0.1),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: () {
                AuthController.instance.passwordReset(resetemailController.text.trim());
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
                      "전송",
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
