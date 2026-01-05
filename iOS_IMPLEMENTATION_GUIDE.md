# iOS 구현 가이드

## 생성된 화면 구조

### 1. MainViewController (Tab Bar Controller)
- 4개 탭:
  - 관광지 (TouristListViewController)
  - 숙박 (AccommodationListViewController)
  - 맛집 (RestaurantListViewController)
  - 추천 (RecommendationViewController)

### 2. 관광지/숙박/맛집 목록 화면
- 검색 기능 포함 (UISearchBar)
- UITableView로 목록 표시
- 셀 클릭 시 상세 페이지로 이동

### 3. 목적지 상세 페이지 (DetailViewController)
- 목적지 상세 정보 표시
- 경로 안내 버튼
- 리뷰 작성 버튼
- 추천 버튼
- 리뷰 목록 표시

### 4. 경로 안내 화면 (RouteViewController)
- 교통수단 선택 (UISegmentedControl)
  - 자동차
  - 도보
  - 자전거
  - 대중교통
- Google Maps에 경로 표시
- 소요 시간 및 거리 표시
- 자동차 모드 선택 시 주유소 및 휴게소 정보 표시

### 5. 관광지 추천 페이지 (RecommendationViewController)
- 현재 위치 기반 추천
- 추천 받기 버튼

## TODO: 실제 구현 필요

### 1. Xcode 프로젝트 생성
현재는 소스 파일만 생성되어 있습니다. Xcode에서 다음 작업이 필요합니다:

1. Xcode에서 새 프로젝트 생성 (iOS > App)
2. 프로젝트 이름: DoDoTravel
3. Interface: Storyboard
4. Language: Swift

### 2. Storyboard 생성
각 화면에 대한 Storyboard 파일을 생성하고 연결해야 합니다:
- Main.storyboard (또는 각 화면별 Storyboard)
- 각 ViewController와 Storyboard 연결
- IBOutlet, IBAction 연결

### 3. XIB 파일 생성
다음 셀의 XIB 파일을 생성해야 합니다:
- DestinationCell.xib
- ReviewCell.xib

### 4. CocoaPods 설치
Podfile에 다음 추가:
```ruby
pod 'GoogleMaps'
pod 'GooglePlaces'
pod 'SDWebImage' # 또는 Kingfisher (이미지 로딩용)
```

터미널에서 실행:
```bash
pod install
```

### 5. API 서비스 구현
`ApiService.swift` 파일에 다음 메서드들을 구현해야 합니다:

```swift
// 관광지 검색
func searchTouristSpots(keyword: String, completion: @escaping (Result<[Destination], Error>) -> Void)

// 숙박 검색
func searchAccommodations(keyword: String, completion: @escaping (Result<[Destination], Error>) -> Void)

// 맛집 검색
func searchRestaurants(keyword: String, completion: @escaping (Result<[Destination], Error>) -> Void)

// 상세 정보 가져오기
func getDestinationDetail(id: String, type: String, completion: @escaping (Result<Destination, Error>) -> Void)

// 경로 정보 가져오기
func getDirections(
    origin: (lat: Double, lng: Double),
    destination: (lat: Double, lng: Double),
    mode: String,
    completion: @escaping (Result<RouteInfo, Error>) -> Void
)

// 주유소 검색
func searchGasStations(
    startLat: Double,
    startLng: Double,
    endLat: Double,
    endLng: Double,
    completion: @escaping (Result<[GasStation], Error>) -> Void
)

// 휴게소 검색
func searchRestAreas(
    startLat: Double,
    startLng: Double,
    endLat: Double,
    endLng: Double,
    completion: @escaping (Result<[RestArea], Error>) -> Void
)

// 추천 관광지 가져오기
func getRecommendations(latitude: Double, longitude: Double, completion: @escaping (Result<[Destination], Error>) -> Void)

// 리뷰 가져오기
func getReviews(destinationId: String, completion: @escaping (Result<[Review], Error>) -> Void)

// 리뷰 작성
func writeReview(destinationId: String, rating: Float, comment: String, completion: @escaping (Result<Void, Error>) -> Void)

// 추천하기
func recommendDestination(destinationId: String, completion: @escaping (Result<Void, Error>) -> Void)
```

### 6. Google Maps Polyline 표시
`RouteViewController.swift`의 `drawRouteOnMap()` 메서드에서:
```swift
import GoogleMaps

let path = GMSPath(fromEncodedPath: routeInfo.polyline)
let polyline = GMSPolyline(path: path)
polyline.strokeColor = .blue
polyline.strokeWidth = 5.0
polyline.map = mapView
```

### 7. 이미지 로딩
DestinationCell에서 이미지를 로드하려면 SDWebImage 또는 Kingfisher를 사용:
```swift
import SDWebImage

thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
```

### 8. Info.plist 설정
- `NSLocationWhenInUseUsageDescription`: 위치 권한 설명
- `GMSApiKey`: Google Maps API Key

### 9. AppDelegate 설정
Google Maps API Key 초기화:
```swift
import GoogleMaps

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    return true
}
```

### 10. SceneDelegate 수정
MainViewController를 rootViewController로 설정:
```swift
func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = MainViewController()
    window?.makeKeyAndVisible()
}
```

## 필요한 권한

- `NSLocationWhenInUseUsageDescription`: 현재 위치 가져오기

## 필요한 API Key

1. **Google Maps API Key**
   - `Info.plist` 또는 `AppDelegate`에 설정
   - Google Cloud Console에서 발급

2. **한국관광공사 TourAPI Key**
   - `ApiService.swift`에 설정

3. **Kakao REST API Key**
   - 주유소/휴게소 검색용
   - `ApiService.swift`에 설정

## 다음 단계

1. Xcode 프로젝트 생성 및 Storyboard 설정
2. 각 API 서비스 구현
3. ViewModel 패턴 적용 (선택사항)
4. 에러 처리 개선
5. 로딩 상태 UI 개선
6. 이미지 캐싱 (SDWebImage/Kingfisher)
7. 데이터베이스 캐싱 (Core Data 또는 Realm, 선택사항)

