import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_blockchain/auth_controller.dart';
import 'package:trust_blockchain/global_variable.dart';
import 'package:trust_blockchain/page/setting_page/private_key_input_screen.dart';
import 'package:trust_blockchain/sign.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final List<String> settingsItems = [
    '개인 키 설정',
    '서명 등록',
    '프로필 설정',
    '계정 관리',
    '앱 정보',
    '문의'
  ];

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "더보기",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        backgroundColor: Color(0xFF256B66),
        elevation: 0,
      ),
      body: Stack(children: [
        // 배경이미지
        Container(
          width: w,
          height: h * 0.2,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("img/background.png"), fit: BoxFit.cover)),
        ),
        // 스크롤 뷰
        SingleChildScrollView(
          child: Column(
            children: [
              // 사용자 정보
              Container(
                margin: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  children: [
                    // 프로필 이미지
                    ClipOval(
                      child: userPhotoURL.isNotEmpty
                          ? Image.network(
                              userPhotoURL,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              "img/profile.png", // 기본 프로필 이미지 경로
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // 이름, 이메일, 사용 용도
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userName,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[100])),
                        Text(userEmail,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[100])),
                        Text(userClassification,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[100])),
                        privateKeyRegistration
                            ? ElevatedButton(
                                onPressed: () {},
                                child: Text("개인 키 등록 완료"),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PrivateKeyInputScreen()),
                                  );
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.deepOrangeAccent),
                                ),
                                child: Text("개인 키 필요")),
                      ],
                    ),
                    SizedBox(
                      width: w * 0.05,
                    ),
                    // 개인키 입력 유무
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // 스크롤 방지
                itemCount: settingsItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(settingsItems[index]),
                    leading: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivateKeyInputScreen()),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignaturePadScreen())
                        );
                      } else if (index == 2) {
                        print("임시");
                      } else if (index == 3) {
                        print("임시");
                      } else if (index == 4) {
                        print("임시");
                      } else if (index == 5) {
                        Get.snackbar(
                          'title',
                          'message',
                          backgroundColor: Colors.redAccent,
                          snackPosition: SnackPosition.BOTTOM,
                          titleText: Text("문의",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          messageText: Text("금오공대 이시영 학생에게 문의바람",
                              style: TextStyle(color: Colors.white)),
                        );
                      } else {
                        print('${settingsItems[index]} 클릭');
                      }
                    },
                  );
                },
              ),
              SizedBox(height: h * 0.1),
              // 로그아웃 버튼
              GestureDetector(
                onTap: () {
                  AuthController.instance.signOut();
                },
                child: Container(
                  width: w * 0.5,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage("img/btn.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "로그아웃",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: h * 0.02),
            ],
          ),
        ),
      ]),
    );
  }
}
