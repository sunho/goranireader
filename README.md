# 고라니 리더 소스 코드

| 경로                | 설명                                   |
|---------------------|----------------------------------------|
| /backend/apiserver  | API 서버의 소스코드입니다.             |
| /backend/dataserver | 데이터 분석 서버의 소스코드입니다.     |
| /frontend           | 아이폰 앱의 소스코드입니다. |
| /admin              | 교사용 관리자 웹의 소스코드입니다.     |

# 요구 사항

## 아이폰 앱

* xcode
* Carthage

## 서버

* golang
* python
* airflow 서버
* cassandra 서버
* postgresql 서버
* kafka 서버
* s3 서버 ([minio](https://min.io/))
* spark 클러스터

## 관리자 웹

* npm

# 빌드

## 아이폰 앱

1. /frontend 에서 아래 커맨드를 실행해주세요.
```
carthage update
```
2. /frontend/FolioReaderKit에서 아래 커맨드를 실행해주세요.
```
carthage update
```
3. /frontend/app.xcworkspace를 xcode로 열어주세요.
4. xcode내의 빌드 버튼을 눌러주세요.

## API 서버

1. /backend/apiserver에서 아래 커맨드를 실행해주세요.
```
go build
```

## 데이터 분석 서버

TODO

## 관리자 웹

1. /admin에서 아래 커맨드를 실행해주세요.
```
npm install
npm run build
```
