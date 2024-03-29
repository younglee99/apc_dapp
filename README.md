# 블록체인을 이용한 농산물 인증 시스템
- 유통업자) ID: a@a.com PW: zxczxc
- 생산자) ID: b@b.com PW: zxczxc
- 소비자) ID: c@c.com PW: zxczxc
---
![그림1](https://github.com/Dangerousmankimchanghwan/Trust_Blockchain/assets/129137919/efafacf9-03c5-41c6-b01d-25498f550768)
---

### 2023-08-08
- 유저인증시스템과 메인화면 결합
- 소비자 아이디로 로그인 하였을 시 ConsumerScreen으로 이동
- 생산자/유통업자/판매자는 ProducerScreen으로 이동

### 2023-08-10
- Storage 폴더명을 사용자 UID로 교체

### 2023-08-11
- 더보기 창 기능 추가
- 메타마스크 개인키 입력란 추가
- 개인 키 해당 유저의 firestore에 저장

### 2023-08-15
- 디폴트 프로필 이미지 오류 수정

### 2023-08-26
- 생산자/소비자에서 -> 생산자/유통업자/소비자로 분리

### 2023-09-13
- 수정된 생산자 메인화면과 QR코드 발급 적용

### 2023-09-15
- QR코드 문제와 스마트컨트렉트 문제해결
- QR코드 출력 버튼위치 AppBar로 이동
- 이미지등록, 인증서, 서명하기, 상세내역 UI 변경
- 앱 로고, 라벨 변경

### 2023-09-17
- 서명 엘범에 저장

### 2023-09-20
- 블록체인에 올린 사진이 다뜨는 문제 해결

### 2023-09-22
- 생산/유통업자 상호명 입력란 추가
- 생산자 -> 유통업자 넘어갈 때 저장버튼 추가
- 저장을 누르면 해당 UID로 농장이름까지 가져오는 것 구현\

### 2023-09-23
- 서명 로컬DB 저장버전 수정

### 2023-09-26
- QR코드 스캔 시 로컬 DB에 생산자 UID, 농장 이름, 등록 날짜를 저장
- 중복되는 UID 일시 저장 불가
- 유통업자 메인화면에 농장 이름과 등록일자 출력
- 생산자의 UID를 통해 스토리지에 접근해서 사진 URL도 가져올 수 있게끔 구현
- 길게 터치하고 있으면 농장 삭제 가능

### 2023-09-27
- 파일명 변경 firbase.dart -> database.dart, distribution.dart -> distribution_to_~~.dart
- 유통업자 QR데이터 변경
- 소비자가 유통업자QR코드 스캔하면, 전역변수에 농장명, 생산자UID, 업데이트날짜 저장까지 구현

### 2023-09-27(1)
- 전체적인 플로우 구현 완성
- 인증서 서명 사진 추가만 하면 완성

### 2023-10-19
- Firebase Storage에 서명 저장
- 서명이 있어야 제품, 유통, 농장 저장가능
- 인증서에 서명 추가 (생산자만...)

### 2023-11-07
- QR코드 스캔 완료 시 화면 복귀 및 새로고침 추가
- 생산자 상품 제거 기능 추가 (일단 보류)
- 생산자 상품 등록 시 안내화면 추가

### 2023-11-09
- 자잘한 오류 수정

### 2023-11-10
- 오류 수정 및 코드 정리
- 스마트 컨트렉트 타이틀 변경 시도 중..

### 2023-11-20
- 오류 수정 및 코드 정리
- 상품 삭제 기능 추가(삭제한 상품명과 날짜를 블록체인에 등록)


