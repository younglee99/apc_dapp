import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'global_variable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ImageData {
  String title; // 이미지 제목
  DateTime? date; // 이미지 업데이트 날짜 (옵션)

  ImageData(this.title, this.date);
}

/*
 #######################################
          Firebase Database
 #######################################
 */
Future<void> getData() async {
  String UID = userUID;
  // Firebase Storage 인스턴스 생성
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // 해당 유저의 'UID/' 폴더 내의 내용을 가져오기 위해 리스트 결과를 얻음
  firebase_storage.ListResult result = await storage.ref('$UID/').list();

  List<ImageData> imageList = []; // ImageData 객체를 담을 리스트

  // 각 이미지 폴더에 대해 루프
  for (firebase_storage.Reference ref in result.prefixes) {
    String title = ref.name.split('/').last; // 이미지 폴더 이름 추출

    firebase_storage.Reference imageRef = storage.ref('$UID/$title/');
    firebase_storage.ListResult result = await imageRef.list();

    DateTime? latestDate; // 최신 업데이트 날짜

    // 이미지 폴더 내의 각 파일에 대해 루프
    for (firebase_storage.Reference imageRef in result.items) {
      firebase_storage.FullMetadata metadata = await imageRef.getMetadata();
      DateTime? imageDate = metadata.updated; // 파일 업데이트 날짜 추출

      if (imageDate != null) {
        // 가장 최신 업데이트 날짜를 찾음
        if (latestDate == null || imageDate.isAfter(latestDate)) {
          latestDate = imageDate;
        }
      }
    }

    // ImageData 객체를 생성하여 리스트에 추가
    imageList.add(ImageData(title, latestDate));
  }

  // 최신 날짜 기준으로 이미지 데이터 리스트를 내림차순으로 정렬
  imageList.sort((a, b) => b.date!.compareTo(a.date!));

  // 외부에서 사용될 변수에 이미지 데이터 정보 저장
  productTitleList = imageList.map((imageData) => imageData.title).toList();
  updateDateList = imageList.map((imageData) => formatDate(imageData.date)).toList();
}

Future<void> getFarmData(producerUID) async {
  String UID = producerUID;
  // Firebase Storage 인스턴스 생성
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // 해당 유저의 'UID/' 폴더 내의 내용을 가져오기 위해 리스트 결과를 얻음
  firebase_storage.ListResult result = await storage.ref('$UID/').list();

  List<ImageData> imageList = []; // ImageData 객체를 담을 리스트

  // 각 이미지 폴더에 대해 루프
  for (firebase_storage.Reference ref in result.prefixes) {
    String title = ref.name.split('/').last; // 이미지 폴더 이름 추출

    firebase_storage.Reference imageRef = storage.ref('$UID/$title/');
    firebase_storage.ListResult result = await imageRef.list();

    DateTime? latestDate; // 최신 업데이트 날짜

    // 이미지 폴더 내의 각 파일에 대해 루프
    for (firebase_storage.Reference imageRef in result.items) {
      firebase_storage.FullMetadata metadata = await imageRef.getMetadata();
      DateTime? imageDate = metadata.updated; // 파일 업데이트 날짜 추출

      if (imageDate != null) {
        // 가장 최신 업데이트 날짜를 찾음
        if (latestDate == null || imageDate.isAfter(latestDate)) {
          latestDate = imageDate;
        }
      }
    }

    // ImageData 객체를 생성하여 리스트에 추가
    imageList.add(ImageData(title, latestDate));
  }

  // 최신 날짜 기준으로 이미지 데이터 리스트를 내림차순으로 정렬
  imageList.sort((a, b) => b.date!.compareTo(a.date!));

  // 외부에서 사용될 변수에 이미지 데이터 정보 저장
  productTitleList = imageList.map((imageData) => imageData.title).toList();
  updateDateList = imageList.map((imageData) => formatDate(imageData.date)).toList();
}

// Firstore에서 UID를 통해 농장이름을 가져옴
Future<String> getFarmName(String producerUID) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final DocumentSnapshot documentSnapshot = await firestore.collection('Producers').doc(producerUID).get();

    if (documentSnapshot.exists) {
      final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      final String businessName = data['businessName'] ?? ''; // 'businessName' 필드에서 농장 이름 가져오기
      print("농장명 가져오기 성공");
      // 농장 이름을 리턴
      return businessName;
    } else {
      print("해당 농장 없음");
    }
  } catch (e) {
    print('Error : $e');
  }
  // 농장 이름을 찾지 못한 경우 기본값인 빈 문자열 리턴
  return '';
}

// 농장UID리스트를 넣으면, 농장이름과 가장 오래된 업데이트 날짜를 전역변수에 저장
Future<void> collectFarmNamesAndDates(List<String?> farmUIDList) async {
  for (String? uid in farmUIDList) {
    if (uid != null) {
      String farmName = await getFarmName(uid);
      if (farmName.isNotEmpty) { // 빈 문자열이 아닌 경우만 추가
        // 농장 이름을 리스트에 추가
        distributorNameList.add(farmName);

        // 해당 UID로부터 가장 최신 날짜를 가져오기 위해 getFarmData 함수 호출
        await getFarmData(uid);

        // 가장 최신 날짜가 updateDateList의 마지막 항목으로 추가되었을 것이므로,
        // 이 값을 가져와서 farmDateList에도 추가
        String? latestDate = updateDateList.last;
        distributorDateList.add(latestDate);
      }
    }
  }
}

// 날짜 형식 변환
String formatDate(DateTime? date) {
  if (date == null) return '';

  String year = date.year.toString();
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}

/*
 #######################################
           SQLlite Database
 #######################################
 */

// 서명 로컬DB 저장
class SignatureDatabase {
  static const String dbName = 'signature.db';
  static const String tableName = 'signatures';

  late Database _database;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            signatureData TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertSignature(String signatureData) async {
    await _database.insert(tableName, {'signatureData': signatureData});
  }

  Future<List<String>> getAllSignatures() async {
    final List<Map<String, dynamic>> maps = await _database.query(tableName);
    return List.generate(maps.length, (i) {
      return maps[i]['signatureData'] as String;
    });
  }
}

// 생산자UID 로컬DB 저장
class ProducerUIDDatabase {
  static const String dbName = 'producer_database.db';
  static const String tableName = 'producer_database';

  late Database _database;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          farmName TEXT,
          producerUID TEXT,
          date TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertFarm(String farmName, String producerUID) async {
    await initializeDatabase();

    // 중복 체크: 이미 동일한 UID가 있는지 확인합니다.
    final existingFarms = await _database.query(
      tableName,
      where: 'producerUID = ?',
      whereArgs: [producerUID],
    );

    if (existingFarms.isEmpty) {
      // 중복되지 않는 경우에만 저장합니다.
      // 현재 시간을 얻어 farmDates 리스트에 추가
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      await _database.insert(tableName, {'farmName': farmName, 'producerUID': producerUID, 'date': formattedDate},);

      print('데이터 삽입 완료: farmName=$farmName, producerUID=$producerUID, date=$formattedDate');

      Get.snackbar("About User", "User message",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("저장 성공", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("해당 농장을 등록하였습니다.", style: TextStyle(color: Colors.white,)),
      );
    } else {
      // 이미 동일한 UID가 있는 경우 아무것도 하지 않습니다.
      print('중복된 UID: farmName=$farmName, producerUID=$producerUID');

      Get.snackbar("About User", "User message",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("저장 실패", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("해당 농장이 이미 등록되어 있습니다.", style: TextStyle(color: Colors.white,)),
      );
    }
  }

  // 로컬DB 농장 삭제
  Future<void> deleteFarm(String producerUID) async {
    await initializeDatabase();

    // producerUID를 기반으로 농장을 삭제합니다.
    await _database.delete(
      tableName,
      where: 'producerUID = ?',
      whereArgs: [producerUID],
    );

    print('데이터 삭제 완료: producerUID=$producerUID');
    Get.snackbar("About User", "User message",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text("제거 완료", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text("해당 농장을 제거하였습니다.", style: TextStyle(color: Colors.white,)),
    );
  }

  Future<List<Map<String, dynamic>>> getFarms() async {
    await initializeDatabase();
    return await _database.query(tableName);
  }
}

// 유통업자UID 로컬DB 저장
class DistributorUIDDatabase {
  static const String dbName = 'distributor_database.db';
  static const String tableName = 'distributor_database';

  late Database _database;

  Future<void> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, dbName);

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          farmName TEXT,
          producerUID TEXT,
          date TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertFarm(String farmName, String producerUID) async {
    await initializeDatabase();

    // 중복 체크: 이미 동일한 UID가 있는지 확인합니다.
    final existingFarms = await _database.query(
      tableName,
      where: 'producerUID = ?',
      whereArgs: [producerUID],
    );

    if (existingFarms.isEmpty) {
      // 중복되지 않는 경우에만 저장합니다.
      // 현재 시간을 얻어 farmDates 리스트에 추가
      final DateTime now = DateTime.now();
      final String formattedDate = DateFormat('yyyy-MM-dd').format(now);

      await _database.insert(tableName, {'farmName': farmName, 'producerUID': producerUID, 'date': formattedDate},);

      print('데이터 삽입 완료: farmName=$farmName, producerUID=$producerUID, date=$formattedDate');

      Get.snackbar("About User", "User message",
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("저장 성공", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("해당 농장을 등록하였습니다.", style: TextStyle(color: Colors.white,)),
      );
    } else {
      // 이미 동일한 UID가 있는 경우 아무것도 하지 않습니다.
      print('중복된 UID: farmName=$farmName, producerUID=$producerUID');

      Get.snackbar("About User", "User message",
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        titleText: Text("저장 실패", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        messageText: Text("해당 농장이 이미 등록되어 있습니다.", style: TextStyle(color: Colors.white,)),
      );
    }
  }

  // 로컬DB 농장 삭제
  Future<void> deleteFarm(String producerUID) async {
    await initializeDatabase();

    // producerUID를 기반으로 농장을 삭제합니다.
    await _database.delete(
      tableName,
      where: 'producerUID = ?',
      whereArgs: [producerUID],
    );

    print('데이터 삭제 완료: producerUID=$producerUID');
    Get.snackbar("About User", "User message",
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text("제거 완료", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      messageText: Text("해당 농장을 제거하였습니다.", style: TextStyle(color: Colors.white,)),
    );
  }

  Future<List<Map<String, dynamic>>> getFarms() async {
    await initializeDatabase();
    return await _database.query(tableName);
  }
}

// 로컬DB에서 가져오는 함수
Future<void> getFarmDataFromDatabase() async {
  if(userClassification == '유통업자'){
    final farms = await ProducerUIDDatabase().getFarms();

    // farmNameList와 farmUIDList를 초기화하고 데이터베이스에서 가져온 값으로 채웁니다.
    farmNameList = farms.map((farm) => farm['farmName'] as String).toList();
    farmUIDList = farms.map((farm) => farm['producerUID'] as String).toList();
    farmDateList = farms.map((farm) => farm['date'] as String).toList();

  } else if(userClassification == '소비자'){
    final farms = await DistributorUIDDatabase().getFarms();

    // farmNameList와 farmUIDList를 초기화하고 데이터베이스에서 가져온 값으로 채웁니다.
    farmNameList = farms.map((farm) => farm['farmName'] as String).toList();
    farmUIDList = farms.map((farm) => farm['producerUID'] as String).toList();
    farmDateList = farms.map((farm) => farm['date'] as String).toList();

  } else{
    return;
  }
}


