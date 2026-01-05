//
//  ApiService.swift
//  DoDoTravel
//
//  API 서비스 클래스 - 관광정보 앱에서 사용할 다양한 API 통합 관리
//

import Foundation

/**
 * API Service 클래스
 * 관광정보 앱에서 사용할 다양한 API를 통합 관리
 * 
 * 주요 API (모두 무료):
 * 1. 한국관광공사 TourAPI - 국내 관광지, 숙박, 맛집 정보
 * 2. Kakao Local API - 국내 장소 검색 (관광지, 맛집, 숙박)
 * 3. OpenStreetMap Nominatim API - 전 세계 장소 검색 (무료)
 * 4. OpenRouteService API - 경로 안내 (무료)
 * 5. Kakao Directions API - 국내 경로 안내 (무료)
 */
class ApiService {
    
    // MARK: - API Base URLs
    
    /// 한국관광공사 TourAPI Base URL
    static let tourApiBaseURL = "http://apis.data.go.kr/B551011/KorService1/"
    
    /// Kakao Local API Base URL
    static let kakaoApiBaseURL = "https://dapi.kakao.com/v2/local/"
    
    /// Kakao Directions API Base URL
    static let kakaoDirectionsBaseURL = "https://apis-navi.kakao.com/v1/directions"
    
    /// OpenStreetMap Nominatim API Base URL (무료, 전 세계)
    static let nominatimBaseURL = "https://nominatim.openstreetmap.org/"
    
    /// OpenRouteService API Base URL (무료, 전 세계 경로 안내)
    static let openRouteServiceBaseURL = "https://api.openrouteservice.org/v2/directions/"
    
    // MARK: - API Keys (실제 사용 시 보안을 위해 Keychain 또는 환경 변수 사용 권장)
    
    static var kakaoRESTAPIKey: String {
        // Info.plist에서 읽어오거나 환경 변수에서 가져오기
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["KakaoRESTAPIKey"] as? String {
            return apiKey
        }
        return "YOUR_KAKAO_REST_API_KEY"
    }
    
    static var tourAPIKey: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["TourAPIKey"] as? String {
            return apiKey
        }
        return "YOUR_TOUR_API_KEY"
    }
    
    /// OpenRouteService API Key (무료, https://openrouteservice.org/ 에서 발급)
    static var openRouteServiceAPIKey: String {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["OpenRouteServiceAPIKey"] as? String {
            return apiKey
        }
        // 무료 API Key는 발급받아야 하지만, 테스트용으로는 선택사항
        return ""
    }
    
    // MARK: - API Documentation
    
    /**
     * 사용 가능한 무료 Open API 목록 및 연동 방법:
     * 
     * 1. 한국관광공사 TourAPI (국내, 무료)
     *    - URL: https://api.visitkorea.or.kr/
     *    - 기능: 관광지, 숙박시설, 음식점 정보
     *    - API Key 발급: https://api.visitkorea.or.kr/openapi/openapi.do
     *    - 예시: http://apis.data.go.kr/B551011/KorService1/searchKeyword?serviceKey={API_KEY}&numOfRows=10&pageNo=1&MobileOS=IOS&MobileApp=DoDoTravel&_type=json&keyword=서울
     * 
     * 2. Kakao Local API (국내, 무료)
     *    - URL: https://developers.kakao.com/docs/latest/ko/local/dev-guide
     *    - 기능: 장소 검색 (관광지, 음식점, 숙박시설, 주유소, 휴게소)
     *    - API Key 발급: Kakao Developers Console (https://developers.kakao.com/)
     *    - 헤더: Authorization: KakaoAK {REST_API_KEY}
     *    - 예시: https://dapi.kakao.com/v2/local/search/keyword.json?query=관광지&x=126.9780&y=37.5665&radius=5000
     * 
     * 3. Kakao Directions API (국내, 무료)
     *    - URL: https://developers.kakao.com/docs/latest/ko/local/dev-guide#directions
     *    - 기능: 경로 안내, 교통수단별 소요시간 (자동차, 도보, 자전거, 대중교통)
     *    - 헤더: Authorization: KakaoAK {REST_API_KEY}
     *    - 예시: https://apis-navi.kakao.com/v1/directions?origin={x},{y}&destination={x},{y}&waypoints=&priority=RECOMMEND&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false
     * 
     * 4. OpenStreetMap Nominatim API (전 세계, 무료)
     *    - URL: https://nominatim.org/release-docs/develop/api/Overview/
     *    - 기능: 장소 검색, 지오코딩 (주소 → 좌표, 좌표 → 주소)
     *    - 제한: 초당 1회 요청 (사용자 에이전트 필수)
     *    - 예시: https://nominatim.openstreetmap.org/search?q=서울&format=json&limit=10
     * 
     * 5. OpenRouteService API (전 세계, 무료)
     *    - URL: https://openrouteservice.org/
     *    - 기능: 경로 안내, 교통수단별 소요시간 (자동차, 도보, 자전거, 대중교통)
     *    - API Key 발급: https://openrouteservice.org/dev/#/signup (무료)
     *    - 헤더: Authorization: {API_KEY}
     *    - 예시: https://api.openrouteservice.org/v2/directions/driving-car?api_key={API_KEY}&start={lon},{lat}&end={lon},{lat}
     * 
     * 6. 한국도로공사 Open API (국내, 무료)
     *    - URL: https://data.ex.co.kr/
     *    - 기능: 고속도로 주유소, 휴게소 정보
     *    - API Key 발급: 공공데이터포털 (https://www.data.go.kr/)
     */
}

// MARK: - API Request Helpers
extension ApiService {
    
    /// HTTP GET 요청 수행
    static func performGETRequest(url: URL, headers: [String: String]? = nil, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
    
    /// 한국관광공사 TourAPI 요청
    static func searchTouristSpots(keyword: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(tourApiBaseURL)searchKeyword?serviceKey=\(tourAPIKey)&numOfRows=10&pageNo=1&MobileOS=IOS&MobileApp=DoDoTravel&_type=json&keyword=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        performGETRequest(url: url) { data, response, error in
            completion(data, error)
        }
    }
    
    /// Kakao Local API 요청 (국내 장소 검색)
    static func searchPlacesNearby(latitude: Double, longitude: Double, keyword: String = "관광지", radius: Int = 5000, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(kakaoApiBaseURL)search/keyword.json?query=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&x=\(longitude)&y=\(latitude)&radius=\(radius)") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var headers: [String: String] = [:]
        headers["Authorization"] = "KakaoAK \(kakaoRESTAPIKey)"
        
        performGETRequest(url: url, headers: headers) { data, response, error in
            completion(data, error)
        }
    }
    
    /// OpenStreetMap Nominatim API 요청 (전 세계 장소 검색)
    static func searchPlacesWithNominatim(query: String, limit: Int = 10, completion: @escaping (Data?, Error?) -> Void) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(nominatimBaseURL)search?q=\(encodedQuery)&format=json&limit=\(limit)") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // OpenStreetMap은 사용자 에이전트 필수
        var headers: [String: String] = [:]
        headers["User-Agent"] = "DoDoTravel iOS App"
        
        performGETRequest(url: url, headers: headers) { data, response, error in
            completion(data, error)
        }
    }
    
    /// Kakao Directions API 요청 (국내 경로 안내)
    static func getDirectionsWithKakao(origin: (lat: Double, lng: Double), destination: (lat: Double, lng: Double), mode: String = "driving", completion: @escaping (Data?, Error?) -> Void) {
        // Kakao API는 경도, 위도 순서
        guard let url = URL(string: "\(kakaoDirectionsBaseURL)?origin=\(origin.lng),\(origin.lat)&destination=\(destination.lng),\(destination.lat)&waypoints=&priority=RECOMMEND&car_fuel=GASOLINE&car_hipass=false&alternatives=false&road_details=false") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var headers: [String: String] = [:]
        headers["Authorization"] = "KakaoAK \(kakaoRESTAPIKey)"
        
        performGETRequest(url: url, headers: headers) { data, response, error in
            completion(data, error)
        }
    }
    
    /// OpenRouteService API 요청 (전 세계 경로 안내)
    static func getDirectionsWithOpenRouteService(origin: (lat: Double, lng: Double), destination: (lat: Double, lng: Double), mode: String = "driving-car", completion: @escaping (Data?, Error?) -> Void) {
        // OpenRouteService는 경도, 위도 순서
        let profile: String
        switch mode {
        case "driving": profile = "driving-car"
        case "walking": profile = "foot-walking"
        case "bicycling": profile = "cycling-regular"
        case "transit": profile = "driving-car" // 대중교통은 별도 API 필요
        default: profile = "driving-car"
        }
        
        guard let apiKey = openRouteServiceAPIKey.isEmpty ? nil : openRouteServiceAPIKey,
              let url = URL(string: "\(openRouteServiceBaseURL)\(profile)?api_key=\(apiKey)&start=\(origin.lng),\(origin.lat)&end=\(destination.lng),\(destination.lat)") else {
            // API Key가 없으면 Kakao API 사용
            getDirectionsWithKakao(origin: origin, destination: destination, mode: mode, completion: completion)
            return
        }
        
        performGETRequest(url: url) { data, response, error in
            completion(data, error)
        }
    }
    
    /// 경로 안내 API (자동으로 국내는 Kakao, 국외는 OpenRouteService 사용)
    static func getDirections(origin: (lat: Double, lng: Double), destination: (lat: Double, lng: Double), mode: String = "driving", completion: @escaping (Data?, Error?) -> Void) {
        // 한국 영역인지 확인 (대략적인 범위)
        let isKorea = (origin.lat >= 33.0 && origin.lat <= 38.6 && origin.lng >= 124.6 && origin.lng <= 132.0) &&
                      (destination.lat >= 33.0 && destination.lat <= 38.6 && destination.lng >= 124.6 && destination.lng <= 132.0)
        
        if isKorea {
            // 국내는 Kakao API 사용
            getDirectionsWithKakao(origin: origin, destination: destination, mode: mode, completion: completion)
        } else {
            // 국외는 OpenRouteService 사용
            getDirectionsWithOpenRouteService(origin: origin, destination: destination, mode: mode, completion: completion)
        }
    }
    
    /// Kakao Local API 요청 (주유소, 휴게소 검색)
    static func searchGasStations(x: Double, y: Double, radius: Int = 5000, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(kakaoApiBaseURL)search/keyword.json?query=주유소&x=\(x)&y=\(y)&radius=\(radius)") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        var headers: [String: String] = [:]
        headers["Authorization"] = "KakaoAK \(kakaoRESTAPIKey)"
        
        performGETRequest(url: url, headers: headers) { data, response, error in
            completion(data, error)
        }
    }
}

