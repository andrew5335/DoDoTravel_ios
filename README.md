# DoDoTravel - 관광정보 앱 (iOS)

관광지, 숙박, 맛집 정보를 제공하고 경로 안내를 제공하는 iOS 앱입니다.

## 주요 기능

- 관광지 정보 제공 (국내/국외)
- 숙박 정보 제공
- 맛집 정보 제공
- 현재 위치에서 목적지까지 경로 안내
- 교통수단별 소요 시간 표시
- 차량 이동 시 주유소 및 휴게소 정보 표시
- 경로 정보를 텍스트 및 지도로 표시
- 관광지 리뷰 기능
- 신규 관광지 추천 기능

## Open API 연동

### 1. 한국관광공사 TourAPI (국내)
- **URL**: https://api.visitkorea.or.kr/
- **기능**: 관광지, 숙박시설, 음식점 정보
- **API Key 발급**: https://api.visitkorea.or.kr/openapi/openapi.do
- **예시 엔드포인트**: 
  ```
  http://apis.data.go.kr/B551011/KorService1/searchKeyword?
  serviceKey={API_KEY}&numOfRows=10&pageNo=1&
  MobileOS=IOS&MobileApp=DoDoTravel&_type=json&keyword=서울
  ```

### 2. Google Places API (국외 + 국내)
- **URL**: https://developers.google.com/places/web-service
- **기능**: 관광지, 음식점, 숙박시설 검색
- **API Key 발급**: Google Cloud Console (https://console.cloud.google.com/)
- **예시 엔드포인트**:
  ```
  https://maps.googleapis.com/maps/api/place/nearbysearch/json?
  location=37.5665,126.9780&radius=1500&type=tourist_attraction&key={API_KEY}
  ```

### 3. Google Maps Directions API
- **URL**: https://developers.google.com/maps/documentation/directions
- **기능**: 경로 안내, 교통수단별 소요시간 (자동차, 대중교통, 도보, 자전거)
- **교통수단**: driving, walking, bicycling, transit
- **예시 엔드포인트**:
  ```
  https://maps.googleapis.com/maps/api/directions/json?
  origin=37.5665,126.9780&destination=37.5651,126.9895&mode=driving&key={API_KEY}
  ```

### 4. Kakao Local API (국내 주유소, 휴게소)
- **URL**: https://developers.kakao.com/docs/latest/ko/local/dev-guide
- **기능**: 주유소, 휴게소 검색
- **API Key 발급**: Kakao Developers Console (https://developers.kakao.com/)
- **헤더**: Authorization: KakaoAK {REST_API_KEY}
- **예시 엔드포인트**:
  ```
  https://dapi.kakao.com/v2/local/search/keyword.json?
  query=주유소&x=126.9780&y=37.5665&radius=5000
  ```

### 5. 한국도로공사 Open API (국내 주유소, 휴게소)
- **URL**: https://data.ex.co.kr/
- **기능**: 고속도로 주유소, 휴게소 정보
- **API Key 발급**: 공공데이터포털 (https://www.data.go.kr/)

### 6. OpenWeatherMap API (선택사항)
- **URL**: https://openweathermap.org/api
- **기능**: 날씨 정보

## 설정 방법

### 1. Xcode 프로젝트 생성
- Xcode에서 새로운 iOS 프로젝트 생성
- 프로젝트 이름: DoDoTravel
- Interface: Storyboard
- Language: Swift

### 2. Google Maps SDK 설치
Podfile에 다음 추가:
```
pod 'GoogleMaps'
pod 'GooglePlaces'
```

터미널에서 실행:
```bash
pod install
```

### 3. API Key 설정
`Info.plist`에서 `GMSApiKey` 값을 실제 Google Maps API Key로 변경하거나,
`AppDelegate.swift`에서 직접 설정:

```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 4. API Key 관리
실제 사용 시에는 다음과 같은 방법으로 API Key를 관리하세요:
- Keychain 사용
- 환경 변수 사용
- 설정 파일 사용 (gitignore에 추가)

## 프로젝트 구조

```
DoDoTravel/
├── Sources/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   ├── SplashViewController.swift
│   ├── MainViewController.swift
│   └── ApiService.swift
├── Resources/
│   ├── LaunchScreen.storyboard
│   ├── Main.storyboard
│   └── Assets.xcassets
└── Info.plist
```

## 빌드 및 실행

1. Xcode에서 프로젝트 열기
2. Google Maps SDK 설치 (CocoaPods 사용 시 .xcworkspace 파일 열기)
3. API Key 설정
4. 시뮬레이터 또는 실제 기기에서 실행

## 필요한 권한

- 위치 권한 (NSLocationWhenInUseUsageDescription)
- 인터넷 권한

## 라이선스

이 프로젝트는 개인 사용을 위해 제작되었습니다.

