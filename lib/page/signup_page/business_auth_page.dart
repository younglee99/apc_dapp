import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trust_blockchain/auth_controller.dart';

class BusinessAuthPage extends StatefulWidget {
  final String email;
  final String name;
  final String phoneNumber;

  const BusinessAuthPage(
      {Key? key,
      required this.email,
      required this.name,
      required this.phoneNumber})
      : super(key: key);

  @override
  State<BusinessAuthPage> createState() => _BusinessAuthPageState();
}

class _BusinessAuthPageState extends State<BusinessAuthPage> {
  Widget? conditionalWidget;
  String? selectedClassification;
  bool numberLengthCheck = true;

  var businessNameController = TextEditingController();
  var businessRegistrationNumberController = TextEditingController();
  var addressController = TextEditingController();

  bool _isAllFieldsFilled() {
    return addressController.text.isNotEmpty &&
        businessRegistrationNumberController.text.isNotEmpty;
  }

  void _checkPhoneNumberLength() {
    setState(() {
      numberLengthCheck =
          businessRegistrationNumberController.text.length == 10;
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
                    "사업자 인증",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "해당 칸에 모두 입력해 주세요.",
                    style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // 분류 선택
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
                    child: DropdownButtonFormField<String>(
                      value: selectedClassification,
                      onChanged: (newValue) {
                        setState(() {
                          selectedClassification =
                              newValue; // 선택된 분류를 문자열로 저장합니다.
                        });
                      },
                      items: <String>['생산자', '유통업자'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
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
                        hintText: '분류 선택',
                        prefixIcon: Icon(
                          Icons.person_search,
                          color: Colors.lightGreen,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // 상호명
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
                              controller: businessNameController,
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
                                hintText: "상호명",
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline_rounded,
                                  color: Colors.lightGreen,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // 사업자등록번호
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
                              controller: businessRegistrationNumberController,
                              onChanged: (_) => _checkPhoneNumberLength(),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
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
                                labelText: "사업자등록번호",
                                hintText: "'-'를 제외하고 입력하세요.",
                                prefixIcon: Icon(
                                  Icons.business_center,
                                  color: Colors.lightGreen,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // 주소
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
                        controller: addressController,
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
                          hintText: "주소",
                          prefixIcon: Icon(
                            Icons.home,
                            color: Colors.lightGreen,
                          ),
                        )),
                  ),
                  SizedBox(height: h * 0.05,),
                ],
              ),
            ),
            // 버튼
            GestureDetector(
              onTap: () {
                if (_isAllFieldsFilled() && numberLengthCheck) {
                  showLoadingIndicator(context);
                  Map<String, dynamic> producerData = {
                    'email': widget.email,
                    'name': widget.name,
                    'phoneNumber': widget.phoneNumber,
                    'classification': selectedClassification,
                    'address': addressController.text.trim(),
                    'businessName' : businessNameController.text.trim(),
                    'businessRegistrationNumber':
                        businessRegistrationNumberController.text.trim(), // 추가 정보
                    'isProducer': true,
                  };
                  AuthController.instance.saveUserData(producerData);
                  Navigator.of(context).pop();
                } else if (!_isAllFieldsFilled()) {
                  Get.snackbar(
                    "Title",
                    "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("정보 저장 실패",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("빈칸을 모두 입력하세요.",
                        style: TextStyle(color: Colors.white)),
                  );
                } else if (!numberLengthCheck) {
                  Get.snackbar(
                    "Title",
                    "Message",
                    backgroundColor: Colors.redAccent,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: Text("정보 저장 실패",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    messageText: Text("'-'없이 10자를 모두 입력하세요.",
                        style: TextStyle(color: Colors.white)),
                  );
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
                      "가입하기",
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
