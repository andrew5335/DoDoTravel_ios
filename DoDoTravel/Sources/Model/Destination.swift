//
//  Destination.swift
//  DoDoTravel
//
//  목적지 모델
//

import Foundation

struct Destination: Codable, Identifiable {
    let id: String
    let name: String
    let type: String // tourist, accommodation, restaurant
    let address: String?
    let latitude: Double
    let longitude: Double
    let phone: String?
    let description: String?
    let imageUrl: String?
    let rating: Double?
    let reviewCount: Int?
    let openHours: String?
}

