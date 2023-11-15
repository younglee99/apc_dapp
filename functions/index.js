const functions = require("firebase-functions");
const admin = require("firebase-admin");

var serviceAccount = require("./trust-blockchain-firebase-adminsdk-ukm34-bbccf074e9.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

// 사용자 정의 토큰(custom token) 생성 함수
exports.createCustomToken = functions.https.onRequest(async (request, response) => {
  const user = request.body;

  // Kakao 로그인 시, uid 앞에 'kakao:'를 추가하여 고유한 사용자 ID(uid) 생성
  const uid = `kakao:${user.uid}`;

  // 사용자 정보 업데이트를 위한 파라미터 설정
  const updateParams = {
    email: user.email,
    photoURL: user.photoURL,
    displayName: user.displayName,
  };

  try {
    // 이미 계정이 있는 경우, 사용자 정보 업데이트
    await admin.auth().updateUser(uid, updateParams);
  } catch (e) {
    // 계정이 없는 경우, 새로운 사용자 생성
    updateParams["uid"] = uid;
    try {
      await admin.auth().createUser(updateParams);
    } catch (e2) {
      // 사용자 생성 실패 시, 오류 처리
      logger.error('사용자 생성 오류:', e2);
      response.status(500).send('사용자 생성 중 오류가 발생하였습니다.');
      return;
    }
  }

  try {
    // 사용자 ID(uid)를 기반으로 사용자 정의 토큰(custom token) 생성
    const token = await admin.auth().createCustomToken(uid);
    response.send(token);
  } catch (e3) {
    // 사용자 정의 토큰 생성 오류 시, 오류 처리
    logger.error('사용자 정의 토큰 생성 오류:', e3);
    response.status(500).send('사용자 정의 토큰 생성 중 오류가 발생하였습니다.');
  }
});
