/*
 #######################################
              전역 변수 모음
 #######################################
 */

// 스마트 컨트렉트
String Eth_Private_Key = "f5bd22493d75c67e7ff8fc8c4769c1cbbe0126db1dd0b2ba37eaeae319deae47";
String Contract_Address = "0x15bf5EeB1A3947d4F37A6BD23Ca3fA445efF40C7";
String Eth_Client = "https://sepolia.infura.io/v3/d834909dd4f0443590207949eef1e469";

// 생산자 필요 변수
List<String> productTitleList = [];
List<String?> updateDateList = [];
List<String> dataList = [];
List<String> dataUrlList = [];
List<String> testList = [];

// 유통업자 필요 변수
String producerUID = '';
List<String> farmNameList = [];
List<String?> farmUIDList = [];
List<String?> farmDateList = [];

// 소비자
List<String?> distributorUIDList = [];
List<String?> distributorNameList = [];
List<String?> distributorDateList = [];

// 사용자 정보
String userUID = '';
String userPhotoURL = '';
String userName = '';
String userEmail = '';
String userPhoneNumber = '';
String userClassification = '';
String userAddress = '';
String userBusinessName = '';
String userBusinessRegistrationNumber = '';

// 메타마스크 가입 유무
bool privateKeyRegistration = false;

// 서명 등록 유뮤
bool isSignatureRegistered = false;