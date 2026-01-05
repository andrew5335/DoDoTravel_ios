//
//  Review.swift
//  DoDoTravel
//
//  리뷰 모델
//

import Foundation

struct Review: Codable, Identifiable {
    let id: String
    let destinationId: String
    let userId: String?
    let userName: String
    let rating: Float // 1.0 ~ 5.0
    let comment: String
    let date: String
}

