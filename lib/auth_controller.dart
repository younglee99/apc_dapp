import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as Kakao;
import 'package:trust_blockchain/page/main_page/distributor_screen.dart';

import 'package:trust_blockchain/page/home_page/home_screen.dart';
import 'package:trust_blockchain/page/main_page/consumer_screen.dart';
import 'package:trust_blockchain/page/main_page/producer_screen.dart';
import 'package:trust_blockchain/page/signup_page/phone_auth_page.dart';
import 'package:trust_blockchain/global_variable.dart';

class AuthController extends GetxController{
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  late User? savingUserInfo;
  late Kakao.User? kakaoUser;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Kakao.UserApi kakao = Kakao.UserApi.instance;
  final GoogleSignIn google = GoogleSignIn();

  // firebase fuction URL (유료임;;)
  final String url = 'https://us-central1-trust-blockchain.cloudfunctions.net/createCustomToken';

  String veificationID = '';
  bool isVerificationInProgress = false;
  bool isRegister = false;
  Timer? reRequestTimer;

  @override
  // 사용자가 변경될 때마다 실행
  void onReady() {
    super.onReady();
    // 로그인을 하였을 경우 사용자의 정보를 담고 있음
    // ※ 로그아웃을 별도로 하지 않는 이상 로그인 유지하는 기능
    _user = Rx<User?>(auth.currentUser);
    // 사용자의 정보 변화를 감시
    _user.bindStream(auth.userChanges());
    // _user가 바뀌면 _screenIndicator함수 호출
    ever(_user, _navigateToScreen);
  }

  // 상황에 알맞게 해당 화면으로 이동
  _navigateToScreen(User? user) async {
    try {
      if (user != null) { // 유저의 정보가 입력 되었을 때
        // Firestore에서 소비자 컬렉션에서 정보를 가져옴
        DocumentSnapshot<Map<String, dynamic>> consumerSnapshot = await firestore
            .collection('Consumers').doc(user.uid).get();
        print("Consumers 컬렉션에서 데이터를 가져옴");
        // 소비자로 저장되어 있다면
        if (consumerSnapshot.exists) {Map<String, dynamic> userData = consumerSnapshot.data()!;

          // 사용자 정보를 전역 변수에 할당
          userUID = user.uid;
          userPhotoURL = user.photoURL ?? '';
          userName = userData['name'] ?? '';
          userEmail = userData['email']?? '';
          userPhoneNumber = userData['phone'] ?? '';
          userClassification = userData['classification'] ?? '';
          isSignatureRegistered = await checkSignatureExists(userUID);

          // 소비자 화면으로 이동
          Get.offAll(() => ConsumerScreen());
          print("Firestore에서 Consumers 컬렉션 데이터 가져오기 완료");
        }
        else { // 소비자에 해당 데이터가 없을 경우
          // Firestore의 생산자 컬렉션에서 정보를 가져옴
          DocumentSnapshot<Map<String, dynamic>> producerSnapshot = await firestore
              .collection('Producers').doc(user.uid).get();
          print("Producers 컬렉션에서 데이터를 가져옴");
          // 생산/유통업자로 저장되어 있다면
          if (producerSnapshot.exists) {
            Map<String, dynamic> userData = producerSnapshot.data()!;

            // 사용자 정보를 전역 변수에 할당
            userUID = user.uid;
            userPhotoURL = user.photoURL ?? '';
            userName = userData['name'] ?? '';
            userEmail = userData['email']?? '';
            userPhoneNumber = userData['phone'] ?? '';
            userClassification = userData['classification'] ?? '';
            userAddress = userData['address'] ?? '';
            userBusinessRegistrationNumber = userData['business'] ?? '';
            userBusinessName = userData['businessName'] ?? '';
            String PK = userData['privateKey']?? '';
            isSignatureRegistered = await checkSignatureExists(userUID);

            // 개인 키가 등록 되어있다면 TRUE
            if(PK.isNotEmpty){
              privateKeyRegistration = true;
            }
            if(userClassification == '생산자'){
              // 생산자 화면으로 이동
              Get.offAll(() => ProducerScreen());
              print("Firestore에서 Producers 컬렉션 데이터 가져오기 완료");
            }
            else if(userClassification == '유통업자'){
              // 유통업자 화면으로 이동
              Get.offAll(() => DistributorScreen());
              print("Firestore에서 Producers 컬렉션 데이터 가져오기 완료");
            }
            else{
              print("사용자의 직업이 없는 경우");
            }
          }
          else {  // 사용자의 정보가 없으면, 로그인 불가
            print("※ 해당 사용자에 대한 정보가 Firestore에 없음");
            print("변경전:$isRegister");
            if(!isRegister) {
              deleteAccount();
            }else{
              isRegister = false;
            }
            print("변경후:$isRegister");
            return;
          }
        }
      }
      else { // 로그인을 하지 않았을 경우
        Get.offAll(() => HomeScreen());
      }
    } catch (e) { // 찐 에러
      print(e.toString());
    }
  }

  // 이메일 가입
  Future<bool> emailRegister(String email, password) async {
    try {
      // email, password로 계정 생성
      isRegister = true;
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      savingUserInfo = userCredential.user;
      Get.snackbar("About User", "User message",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("계정 생성 성공", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text(email+"로 계정을 생성하였습니다.", style: TextStyle(color: Colors.white,)),
      );
      return true;
    } catch (e) {
      // 계정 생성 실패
      print(e.toString());
      errorSnackbar(e);
      return false;
    }
  }

  // 구글 가입 및 로그인
  Future<void> googleSignIn() async {
    try {
      isRegister = true;
      // 구글 로그인 다이얼로그 표시 및 사용자 선택
      final GoogleSignInAccount? googleUser = await google.signIn();
      // 사용자가 취소한 경우 또는 선택하지 않은 경우
      if (googleUser == null) {
        return;
      }
      // GoogleSignInAccount를 Firebase에서 사용 가능한 자격 증명으로 변환
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Firebase에 자격 증명으로 로그인
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      savingUserInfo = userCredential.user;
      final User? user = userCredential.user;
      // 신규 가입시 사용자 정보 입력 화면으로 이동
      if (user != null) {
        Get.offAll(() => PhoneAuthPage(email: user.email!));
      } // 정보가 있다면, ScreenIndicator에 의해 자동으로 소비자/생산자 화면으로 이동
    } catch (e) {
      print('구글 로그인 실패: $e');
    }
  }

  // 카카오 가입 및 로그인
  Future<void> kakaoSignIn() async {
    try {
      isRegister = true;
      bool isKakaoSignIn = false;
      bool isInstalled = await Kakao.isKakaoTalkInstalled();
      if (isInstalled) { // 카카오톡이 설치되어있다면
        try {
          // 카카오톡으로 로그인
          await kakao.loginWithKakaoTalk();
          isKakaoSignIn = true;
        } catch (e) {
          print("로그인 실패:$e");
        }
      }
      else { // 설치가 안되어있는 경우
        try {
          // 카카오 계정으로 로그인을 유도
          await kakao.loginWithKakaoAccount();
          isKakaoSignIn = true;
        } catch (e) {
          print("로그인 실패:$e");
        }
      }
      if(isKakaoSignIn){
        print("카카오로 로그인 성공");
        kakaoUser = await kakao.me();
        // 유저 정보를 받고 서버로 정보를 보내줘야함
        final token = await createCustomToken({
          'uid': kakaoUser!.id.toString(),
          'displayName': kakaoUser!.kakaoAccount!.profile!.nickname,
          'email': kakaoUser!.kakaoAccount!.email!,
          'photoURL': kakaoUser!.kakaoAccount!.profile!.profileImageUrl!,
        });
        final UserCredential userCredential = await auth.signInWithCustomToken(token);
        savingUserInfo = userCredential.user;
        final User? user = userCredential.user;
        // 신규 가입시 사용자 정보 입력 화면으로 이동
        if (user != null) {
          Get.offAll(() => PhoneAuthPage(email: user.email!));
        } // 정보가 있다면, ScreenIndicator에 의해 자동으로 소비자/생산자 화면으로 이동
      }
    } catch (e) {
      print("카카오 로그인 실패:$e");
    }
  }

  // 이메일 로그인
  void signIn(String email, password)async{
    try{
      await auth.signInWithEmailAndPassword(email: email, password: password);
      print("로그인 성공");
    }catch(e){
      errorSnackbar(e);
    }
  }

  // 로그아웃
  void signOut()async{
    Get.offAll(() => HomeScreen());
    // Firebase 로그아웃
    await auth.signOut();
    // Kakao 로그아웃
    await Kakao.UserApi.instance.unlink();
    // Google 로그아웃
    await google.signOut();
  }

  // 계정 삭제
  Future<void> deleteAccount() async {
    try {
      User? user = auth.currentUser; // 현재 로그인한 사용자 정보 가져오기

      if (user != null) {
        await user.delete();
        signOut();
        print("계정 삭제 성공");
      } else {
        print("가입된 사용자 없음");
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'requires-recent-login':
          Get.snackbar("오류", "로그인 후 다시 시도해주세요.");
          break;
        default:
          Get.snackbar("오류", "계정을 삭제할 수 없습니다.");
          print("계정 삭제 오류: $e");
          break;
      }
    } catch (e) {
      print("계정 삭제 오류 : $e");
    }
  }

  // 사용자 정보 Firestore에 저장
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    // 소비자인 경우 해당 정보를 가지고 다음 함수로 이동
    if (!userData['isProducer']) {
      await saveConsumerInfo(
          savingUserInfo!.uid,
          userData['email'],
          userData['name'],
          userData['phoneNumber'],
          userData['classification']);
    }
    // 소비자가 아닌 경우 생산/유통업자 함수 이동
    else {
      await saveProducerInfo(
        savingUserInfo!.uid,
        userData['email'],
        userData['name'],
        userData['phoneNumber'],
        userData['address'],
        userData['businessRegistrationNumber'],
        userData['businessName'],
        userData['classification'],
      );
    }
  }

  // 소비자란에 Firestore 저장
  Future<void> saveConsumerInfo(String userId, email, name, phoneNumber, classification) async {
    // 컬렉션 생성
    CollectionReference consumerCollection = firestore.collection('Consumers');
    // 사용자 정보 추가
    await consumerCollection.doc(userId).set({
      'email': email,
      'name': name,
      'phone': phoneNumber,
      'classification': classification,
    });
    print("소비자 정보 저장 완료");
    // _navigateToScreen(savingUserInfo);
    deleteAccount();
    Get.snackbar(name, "User message",
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(name+"님 반갑습니다!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text("로그인을 진행해주세요.", style: TextStyle(color: Colors.white,)),
    );
  }

  // 생산자란에 Firestore 저장
  Future<void> saveProducerInfo(String userId, email, name, phoneNumber, address, businessRegistrationNumber, businessName, classification) async {
    // 컬렉션 생성
    CollectionReference producersCollection = firestore.collection('Producers');
    // 사용자 정보 추가
    await producersCollection.doc(userId).set({
      'email': email,
      'name': name,
      'phone': phoneNumber,
      'address' : address,
      'business' : businessRegistrationNumber,
      'businesName' : businessName,
      'classification': classification,
    });
    print("생산/유통업자 정보 저장 완료");
    deleteAccount();
    Get.snackbar(name, "User message",
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(name+"님 반갑습니다!", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text("로그인을 진행해주세요.", style: TextStyle(color: Colors.white,)),
    );
  }

  // Kakao전용 Firebase Auth에 등록할 때 필요한 커스텀 토큰
  Future<String> createCustomToken(Map<String, dynamic> user) async {
    final customTokenResponse = await http.post(Uri.parse(url), body: user);
    return customTokenResponse.body;
  }

  // 인증번호 전송
  void sendAuthNumber(String phoneNumber, Function(bool) callback) async {
    List<String> phoneNumbers = await getAllPhoneNumbers();
    // 전화번호 중복 확인
    bool isPhoneNumberDuplicate = phoneNumbers.contains(phoneNumber);
    if (isPhoneNumberDuplicate) {
      Get.snackbar("title", "message",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("중복된 번호", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        messageText: Text("이미 등록된 번호입니다.", style: TextStyle(color: Colors.white),),
      );
      return;
    }
    // 전화번호 형식으로 변환
    String formattedPhoneNumber = phoneNumber.replaceFirstMapped(
      RegExp(r'^(\d{3})(\d{4})(\d{4})$'),
          (match) => '${match[1]}-${match[2]}-${match[3]}',
    );
    // 전화번호 검증
    await auth.verifyPhoneNumber(
      phoneNumber: "+82" + phoneNumber,
      timeout: const Duration(seconds: 60),
      // 자동 코드 입력
      codeAutoRetrievalTimeout: (String verificationId) {
        print('자동입력 타임아웃 : $verificationId');
      },
      // 인증 코드 전송
      codeSent: (String verificationId, int? resendToken) {
        this.veificationID = verificationId;
        print('인증 코드 전송: $verificationId');
        bool requestedAuth=true;
        callback(requestedAuth);
        Get.snackbar("Auth User", "Auth message",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          titleText: Text("인증 코드 전송", style: TextStyle(color: Colors.white,  fontWeight: FontWeight.bold)),
          messageText: Text(formattedPhoneNumber + "\n번호로 코드를 전송하였습니다.", style: TextStyle(color: Colors.white)),
        );
      },
      // 코드 발송 성공
      verificationCompleted: (PhoneAuthCredential credential) async {
        await auth.signInWithCredential(credential);
        print('코드 발송 성공');
      },
      // 코드 발송 실패
      verificationFailed: (FirebaseAuthException e) {
        print('코드 발송 실패: $e');
        errorSnackbar(e);
      },
    );
  }

  // 인증번호 검증
  void authNumberVerification(String smsCode,  Function(bool) callback) async{
    try{
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: veificationID,
        smsCode: smsCode,
      );
      try {
        isRegister = true;
        final authCredential = await auth.signInWithCredential(credential);
        if(authCredential.user != null){
          print("인증 완료");
          bool authStatus=true;
          callback(authStatus);
        }
      }  catch (e) {
        print("인증/로그인 실패 :"+ e.toString());
        errorSnackbar(e);
      }
    } catch(e) {
      print('인증 실패: $e');
      errorSnackbar(e);
    }
  }

  // 전화번호 리스트화
  Future<List<String>> getAllPhoneNumbers() async {
    List<String> phoneNumbers = [];
    try {
      // Firestore 컬렉션에서 정보를 가져옴
      QuerySnapshot<Map<String, dynamic>> consumerSnapshot = await firestore.collection('Consumers').get();
      QuerySnapshot<Map<String, dynamic>> producerSnapshot = await firestore.collection('Producers').get();

      // 가져온 모든 문서를 순회하면서 전화번호를 추출하여 리스트에 추가
      for (var doc in consumerSnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        String phoneNumber = data['phone'];
        phoneNumbers.add(phoneNumber);
      }
      for (var doc in producerSnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        String phoneNumber = data['phone'];
        phoneNumbers.add(phoneNumber);
      }
    } catch (e) {
      print('전화번호 가져오기 실패: $e');
    }
    print("사용자 전화번호 리스트: $phoneNumbers");
    return phoneNumbers;
  }

  // 비밀번호 찾기
  void passwordReset(String email) async {
    try {
      List<String> user = await auth.fetchSignInMethodsForEmail(email);
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar("About User", "User message",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("링크 전송", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text(email + "으로 링크를 전송하였습니다.", style: TextStyle(color: Colors.white)),
      );
    } catch(e) {
      print(e.toString());
      errorSnackbar(e);
    }
  }

  // 개인 키 firestore에 저장
  void privateKeySave(String privateKey, String userUID) async {
    try {
      // Firestore 문서 업데이트
      await firestore.collection('Producers').doc(userUID).update({
        'privateKey': privateKey,
      });
      privateKeyRegistration = true;
      Get.snackbar('title', 'message',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("저장 성공", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("개인 키를 저장하였습니다.", style: TextStyle(color: Colors.white)),
      );
    } catch (error) {
      privateKeyRegistration = false;
      print('Error updating private key: $error');
      Get.snackbar('title', 'message',
        backgroundColor: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("저장 실패", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("$error", style: TextStyle(color: Colors.white)),
      );
    }
  }

  // 서명 등록 유무 확인
  Future<bool> checkSignatureExists(String UID) async {
    Reference ref = FirebaseStorage.instance.ref().child("서명/$UID.png");

    try {
      // 해당 위치의 파일의 메타데이터를 가져옵니다.
      await ref.getMetadata();

      // getMetadata()가 에러 없이 완료되면, 파일이 존재하는 것입니다.
      return true;
    } catch (e) {
      // 에러가 발생하면, 파일이 존재하지 않는 것입니다.
      return false;
    }
  }

  // 에러 알림
  void errorSnackbar(dynamic error) {
    String title = "";
    String message = '';

    if (error is FirebaseAuthException) {
      FirebaseAuthException authException = error;
      if (authException.code == 'email-already-in-use') {
        title = "이메일 오류";
        message = "이메일이 이미 다른 사용자에게 등록되어 있습니다.";
      } else if (authException.code == 'user-not-found') {
        title = "이메일 오류";
        message = "해당 이메일을 가진 사용자가 존재하지 않습니다.";
      }  else if (authException.code == 'invalid-email') {
        title = "이메일 오류";
        message = "올바르지 않은 형식의 이메일을 입력하셨습니다.";
      } else if (authException.code == 'wrong-password') {
        title = "비밀번호 오류";
        message = "비밀번호가 다릅니다. 다시 입력해 주세요.";
      } else if (authException.code == 'user-disabled') {
        title = "계정 오류";
        message = "해당 사용자 계정이 비활성화되어 있습니다.";
      } else if (authException.code == 'too-many-requests') {
        title = "인증 오류";
        message = "너무 많은 요청이 발생하여 일시적으로 차단되었습니다.";
      } else if (authException.code == 'invalid-verification-code') {
        title = "인증 오류";
        message = "인증 코드(OTP)가 유효하지 않습니다.";
      } else if (authException.code == 'invalid-phone-number') {
        title = "인증 오류";
        message = "형식에 맞게 번호를 입력해 주세요.";
      } else if (authException.code == 'unknown') {
        title = "인증 오류";
        message = "빈칸을 입력하세요.";
      } else if (authException.code == 'network-request-failed') {
        title = "네트워크 오류";
        message = "네트워크 연결 상태를 확인하세요.";
      } else{
        title = "오류";
        message = error.toString();
      }
    } else{
      title = "오류";
      message = error.toString();
    }
    Get.snackbar(title, message,
      backgroundColor: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}