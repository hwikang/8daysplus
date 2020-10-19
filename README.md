# 8DAYS Plutter Project

### Structure
core : 공통 라이브러리 
mobile : 앱 개발 프로젝트
web : web for admin 

### Core 
Business logic using Bloc pattern & data model for mobile and web

### Mobile

```
cd mobile && flutter run
```

### Web  
* install pub & execute web serve
cd web
pub global activate webdev
webdev build



### Reference 
https://medium.com/flutterpub/effective-bloc-pattern-45c36d76d5fe



### 안드로이드 개발시 참고 
키파일 관련 에러가 발생시 
key.properties파일을 추가해서 값을 세팅해줘야함.
project path/mobile/android에 key.properties을 추가하며 

```
storePassword=@gtention6969?!
keyPassword=@gtention6969?!
keyAlias=key
storeFile=~/the8days/flutter/dev_plus_flutter/mobile/keys/key.jks
```

을 세팅해준다. 
또한 key파일은 따로 저장해서 관리해서 사용한다. 

## 디버그 해시키
keytool -exportcert -alias androiddebugkey -keystore  ~/.android/debug.keystore -storepass android -keypass android | openssl sha1 -binary | openssl base64

	

## 릴리즈 해시키 
echo <구글플레이스토어->앱서명->앱서명 인증서 sha1 인증서 지문> | xxd -r -p | openssl base64

(키해시 oeTx************)

##sha1 인증서
keytool -exportcert -list -v -alias <key이름> -keystore <keystore 경로>
ex>keytool -exportcert -list -v -alias key -keystore /Users/hwikang/keys/8daysplus/key.jks

##디버그용 sha1 인증서
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

