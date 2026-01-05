# API 연동 가이드 (iOS)

## 1. 한국관광공사 TourAPI (국내 관광지, 숙박, 맛집)

### API Key 발급
1. https://api.visitkorea.or.kr/openapi/openapi.do 접속
2. 회원가입 후 로그인
3. "오픈API" 메뉴에서 "인증키 발급" 신청
4. 발급받은 API Key를 `ApiService.swift`의 `tourAPIKey`에 설정

### 주요 엔드포인트
- **관광지 검색**: `/searchKeyword` - 키워드로 관광지 검색
- **숙박 검색**: `/searchStay` - 숙박시설 검색
- **음식점 검색**: `/searchRestaurant` - 음식점 검색
- **상세 정보**: `/detailCommon1` - 관광지 상세 정보

### 예시 요청
```swift
ApiService.searchTouristSpots(keyword: "서울") { data, error in
    // 데이터 처리
}
```

## 2. Google Places API (국외 + 국내)

### API Key 발급
1. https://console.cloud.google.com/ 접속
2. 새 프로젝트 생성
3. "API 및 서비스" > "라이브러리"에서 다음 API 활성화:
   - Places API
   - Maps SDK for iOS
   - Directions API
   - Geocoding API
4. "사용자 인증 정보"에서 API 키 생성
5. API 키 제한 설정 (권장: iOS 앱 제한)

### 주요 엔드포인트
- **주변 검색**: `/place/nearbysearch/json` - 주변 관광지, 음식점 검색
- **텍스트 검색**: `/place/textsearch/json` - 텍스트로 장소 검색
- **상세 정보**: `/place/details/json` - 장소 상세 정보

### 예시 요청
```swift
ApiService.searchPlacesNearby(
    latitude: 37.5665,
    longitude: 126.9780,
    type: "tourist_attraction",
    radius: 1500
) { data, error in
    // 데이터 처리
}
```

## 3. Google Maps Directions API (경로 안내)

### API Key
Google Places API와 동일한 API Key 사용

### 주요 파라미터
- `origin`: 출발지 (위도,경도 또는 주소)
- `destination`: 목적지 (위도,경도 또는 주소)
- `mode`: 교통수단 (driving, walking, bicycling, transit)
- `waypoints`: 경유지 (선택사항)
- `alternatives`: 대안 경로 여부 (true/false)

### 예시 요청
```swift
ApiService.getDirections(
    origin: (lat: 37.5665, lng: 126.9780),
    destination: (lat: 37.5651, lng: 126.9895),
    mode: "driving"
) { data, error in
    // 경로 데이터 처리
}
```

### 응답 데이터 구조
```swift
struct DirectionsResponse: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let legs: [Leg]
    let overview_polyline: OverviewPolyline
}

struct Leg: Codable {
    let duration: Duration
    let distance: Distance
    let steps: [Step]
}
```

## 4. Kakao Local API (국내 주유소, 휴게소)

### API Key 발급
1. https://developers.kakao.com/ 접속
2. 내 애플리케이션 만들기
3. REST API 키 발급받기
4. 플랫폼 설정 (iOS 번들 ID 등록)

### 주요 엔드포인트
- **키워드 검색**: `/v2/local/search/keyword.json` - 주유소, 휴게소 검색
- **카테고리 검색**: `/v2/local/search/category.json` - 카테고리별 검색

### 요청 헤더
```
Authorization: KakaoAK {REST_API_KEY}
```

### 예시 요청
```swift
ApiService.searchGasStations(x: 126.9780, y: 37.5665, radius: 5000) { data, error in
    // 주유소 데이터 처리
}
```

## 5. Google Maps SDK (지도 표시)

### CocoaPods 설치
```bash
pod 'GoogleMaps'
pod 'GooglePlaces'
```

### 사용 예시
```swift
import GoogleMaps

// AppDelegate에서 API Key 설정
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")

// 지도 표시
let camera = GMSCameraPosition.camera(withLatitude: 37.5665, longitude: 126.9780, zoom: 15.0)
let mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
view.addSubview(mapView)

// 경로 표시
let path = GMSPath(fromEncodedPath: polylineString)
let polyline = GMSPolyline(path: path)
polyline.strokeColor = .blue
polyline.strokeWidth = 5.0
polyline.map = mapView
```

## API Key 관리 (보안)

### 방법 1: Info.plist (개발용)
```xml
<key>GMSApiKey</key>
<string>YOUR_GOOGLE_MAPS_API_KEY</string>
```

### 방법 2: Keychain (프로덕션 권장)
```swift
import Security

func saveAPIKey(_ key: String, forService service: String) {
    let data = key.data(using: .utf8)!
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecValueData as String: data
    ]
    SecItemAdd(query as CFDictionary, nil)
}

func getAPIKey(forService service: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: service,
        kSecReturnData as String: true
    ]
    var result: AnyObject?
    SecItemCopyMatching(query as CFDictionary, &result)
    if let data = result as? Data {
        return String(data: data, encoding: .utf8)
    }
    return nil
}
```

### 방법 3: 환경 변수
Xcode Scheme에서 환경 변수 설정:
1. Edit Scheme > Run > Arguments > Environment Variables
2. Key-Value 쌍 추가

## 주의사항

1. **API Key 보안**: API Key는 절대 코드에 하드코딩하지 마세요. Keychain 또는 환경 변수 사용
2. **API 사용량 제한**: 각 API마다 일일 사용량 제한이 있으므로 확인 필요
3. **에러 처리**: 네트워크 에러, API 에러 등에 대한 적절한 에러 처리 구현
4. **비용**: Google Maps API는 사용량에 따라 과금되므로 주의
5. **정책 준수**: 각 API의 이용약관 및 정책을 확인하고 준수
6. **Info.plist 설정**: 위치 권한 사용 설명 추가 필수

