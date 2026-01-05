//
//  RouteInfo.swift
//  DoDoTravel
//
//  경로 정보 모델
//

import Foundation

struct RouteInfo: Codable {
    let mode: String // driving, walking, bicycling, transit
    let duration: String // 소요 시간 (텍스트)
    let durationSeconds: Int64 // 소요 시간 (초)
    let distance: String // 거리 (텍스트)
    let distanceMeters: Int64 // 거리 (미터)
    let polyline: String // 경로 폴리라인
    let steps: [RouteStep]
}

struct RouteStep: Codable {
    let instruction: String
    let distance: String
    let duration: String
}

struct GasStation: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

struct RestArea: Codable, Identifiable {
    let id: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
}

