import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:trust_blockchain/auth_controller.dart';
import 'package:trust_blockchain/page/signup_page/business_auth_page.dart';

class PhoneAuthPage extends StatefulWidget {
  final String email;

  const PhoneAuthPage({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {
  bool isProducerSelected = false;
  bool numberLengthCheck = true;
  bool authStatus = false;
  bool requestedAuth = false;

  late Timer _timer;
  int _timeRemaining = 60;

  var nameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var verificationController = TextEditingController();

  bool _isAllFieldsFilled() {
    return nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
  }

  void _checkPhoneNumberLength() {
    setState(() {
      numberLengthCheck = phoneNumberController.text.length == 11;
    });
  }

  void _startTimer() {
    _timeRemaining = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          timer.cancel();
          requestedAuth = false;
          Get.snackbar(
            "Title",
            "Message",
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            titleText: Text("타임 아웃",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            messageText: Text("휴대폰 인증을 다시 시도해 주세요.",
                style: TextStyle(color: Colors.white)),
          );
        }
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
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
            AuthController.instance.deleteAccount();
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
                    "본인 인증",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "이름과 휴대폰 인증을 해주세요.",
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                        controller: nameController,
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
                          hintText: "이름",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.lightGreen,
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: Offset(1, 1),
                          color: Colors.grey.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: phoneNumberController,
                              enabled: !authStatus,
                              onChanged: (_) => _checkPhoneNumberLength(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              // 입력 제한 설정
                              keyboardType: TextInputType.phone,
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
                                labelText: "전화번호",
                                hintText: "'-'를 제외하고 입력하세요.",
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.lightGreen,
                                ),
                              )),
                        ),
                        authStatus // 휴대폰 인증을 완료하였을 때 = True
                            ? ElevatedButton(
                                onPressed: () {},
                                child: Text("인증\n완료"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(40, 62)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  if (numberLengthCheck) {
                                    showLoadingIndicator(context);
                                    AuthController.instance.sendAuthNumber(phoneNumberController.text.trim(), (_requestedAuth) {
                                      setState(() {
                                        requestedAuth = _requestedAuth;
                                        _startTimer();
                                      });
                                    Navigator.of(context).pop();
                                    });
                                  } else {
                                    Get.snackbar(
                                      "About Auth",
                                      "Auth message",
                                      backgroundColor: Colors.redAccent,
                                      snackPosition: SnackPosition.BOTTOM,
                                      titleText: Text("잘못된 번호",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      messageText: Text(
                                          "'010'부터 번호를 다시 입력해 주세요.",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    );
                                  }
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(40, 62)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.deepOrangeAccent;
                                      return null;
                                    },
                                  ),
                                ),
                                child: Text("인증\n요청")),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: requestedAuth,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: Offset(1, 1),
                                color: Colors.grey.withOpacity(0.2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: verificationController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ], // 숫자만 입력 설정
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          borderSide: BorderSide(
                                            color: Colors.white,
                                            width: 1.0,
                                          )),
                                      hintText: "인증번호",
                                      prefixIcon: Icon(
                                        Icons.numbers,
                                        color: Colors.orange,
                                      )),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  AuthController.instance
                                      .authNumberVerification(
                                          verificationController.text.trim(),
                                          (_authStatus) {
                                    setState(() {
                                      authStatus = _authStatus;
                                      requestedAuth = false;
                                      _stopTimer();
                                    });
                                  });
                                },
                                child: Text("확인"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  minimumSize:
                                      MaterialStateProperty.all(Size(40, 62)),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.orange),
                                  overlayColor:
                                      MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (states
                                          .contains(MaterialState.pressed))
                                        return Colors.deepOrangeAccent;
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          '남은 시간: $_timeRemaining초',
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isProducerSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            isProducerSelected = value ?? false;
                          });
                        },
                      ),
                      Text('소비자가 아닐 경우 눌러주세요.',
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[500])),
                    ],
                  ),
                  SizedBox(height: h * 0.1),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: () {
                if (_isAllFieldsFilled() && authStatus) {
                  if (isProducerSelected) {
                    // 생산자라면 다음 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BusinessAuthPage(
                                email: widget.email,
                                name: nameController.text.trim(),
                                phoneNumber: phoneNumberController.text.trim(),
                              )),
                    );
                  } else {
                    // 소비자인 경우 회원가입 진행
                    Map<String, dynamic> consumerData = {
                      'email': widget.email,
                      'name': nameController.text.trim(),
                      'phoneNumber': phoneNumberController.text.trim(),
                      'classification': "소비자",
                      'isProducer': false,
                    };
                    AuthController.instance.saveUserData(consumerData);
                  }
                }
                // 경고 메시지
                if (!_isAllFieldsFilled()) {
                  Get.snackbar(
                    "Title",
                    "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("계정 생성 실패",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("빈칸을 모두 입력하세요.",
                        style: TextStyle(color: Colors.white)),
                  );
                  return;
                }
                if (!authStatus) {
                  Get.snackbar(
                    "Title",
                    "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("계정 생성 실패",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("휴대폰 인증을 완료하세요.",
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
                        image: AssetImage("img/btn.png"), fit: BoxFit.cover)),
                child: Center(
                  child: Text(
                    isProducerSelected ? "다음" : "가입하기",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
