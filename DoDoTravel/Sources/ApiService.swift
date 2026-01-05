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
 * 주요 API:
 * 1. 한국관광공사 TourAPI - 국내 관광지, 숙박, 맛집 정보
 * 2. Google Places API - 국외 관광지, 맛집 정보
 * 3. Google Maps Directions API - 경로 안내
 * 4. Kakao Local API - 주유소, 휴게소 정보
 */
class ApiService {
    
    // MARK: - API Base URLs
    
    /// 한국관광공사 TourAPI Base URL
    static let tourApiBaseURL = "http://apis.data.go.kr/B551011/KorService1/"
    
    /// Google Maps API Base URL
    static let googleMapsBaseURL = "https://maps.googleapis.com/maps/api/"
    
    /// Kakao Local API Base URL
    static let kakaoApiBaseURL = "https://dapi.kakao.com/v2/local/"
    
    // MARK: - API Keys (실제 사용 시 보안을 위해 Keychain 또는 환경 변수 사용 권장)
    
    static var googleMapsAPIKey: String {
        // Info.plist에서 읽어오거나 환경 변수에서 가져오기
        return "YOUR_GOOGLE_MAPS_API_KEY"
    }
    
    static var kakaoRESTAPIKey: String {
        return "YOUR_KAKAO_REST_API_KEY"
    }
    
    static var tourAPIKey: String {
        return "YOUR_TOUR_API_KEY"
    }
    
    // MARK: - API Documentation
    
    /**
     * 사용 가능한 Open API 목록 및 연동 방법:
     * 
     * 1. 한국관광공사 TourAPI (국내)
     *    - URL: https://api.visitkorea.or.kr/
     *    - 기능: 관광지, 숙박시설, 음식점 정보
     *    - API Key 발급: https://api.visitkorea.or.kr/openapi/openapi.do
     *    - 예시: http://apis.data.go.kr/B551011/KorService1/searchKeyword?serviceKey={API_KEY}&numOfRows=10&pageNo=1&MobileOS=IOS&MobileApp=DoDoTravel&_type=json&keyword=서울
     * 
     * 2. Google Places API (국외 + 국내)
     *    - URL: https://developers.google.com/places/web-service
     *    - 기능: 관광지, 음식점, 숙박시설 검색
     *    - API Key 발급: Google Cloud Console (https://console.cloud.google.com/)
     *    - 예시: https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.5665,126.9780&radius=1500&type=tourist_attraction&key={API_KEY}
     * 
     * 3. Google Maps Directions API
     *    - URL: https://developers.google.com/maps/documentation/directions
     *    - 기능: 경로 안내, 교통수단별 소요시간 (자동차, 대중교통, 도보, 자전거)
     *    - 교통수단: driving, walking, bicycling, transit
     *    - 예시: https://maps.googleapis.com/maps/api/directions/json?origin=37.5665,126.9780&destination=37.5651,126.9895&mode=driving&key={API_KEY}
     * 
     * 4. Kakao Local API (국내 주유소, 휴게소)
     *    - URL: https://developers.kakao.com/docs/latest/ko/local/dev-guide
     *    - 기능: 주유소, 휴게소 검색
     *    - API Key 발급: Kakao Developers Console (https://developers.kakao.com/)
     *    - 헤더: Authorization: KakaoAK {REST_API_KEY}
     *    - 예시: https://dapi.kakao.com/v2/local/search/keyword.json?query=주유소&x=126.9780&y=37.5665&radius=5000
     * 
     * 5. 한국도로공사 Open API (국내 주유소, 휴게소)
     *    - URL: https://data.ex.co.kr/
     *    - 기능: 고속도로 주유소, 휴게소 정보
     *    - API Key 발급: 공공데이터포털 (https://www.data.go.kr/)
     * 
     * 6. OpenWeatherMap API (선택사항)
     *    - URL: https://openweathermap.org/api
     *    - 기능: 날씨 정보
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
    
    /// Google Places API 요청 (관광지 검색)
    static func searchPlacesNearby(latitude: Double, longitude: Double, type: String = "tourist_attraction", radius: Int = 1500, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(googleMapsBaseURL)place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(radius)&type=\(type)&key=\(googleMapsAPIKey)") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        performGETRequest(url: url) { data, response, error in
            completion(data, error)
        }
    }
    
    /// Google Maps Directions API 요청
    static func getDirections(origin: (lat: Double, lng: Double), destination: (lat: Double, lng: Double), mode: String = "driving", completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(googleMapsBaseURL)directions/json?origin=\(origin.lat),\(origin.lng)&destination=\(destination.lat),\(destination.lng)&mode=\(mode)&key=\(googleMapsAPIKey)") else {
            completion(nil, NSError(domain: "ApiService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        performGETRequest(url: url) { data, response, error in
            completion(data, error)
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

