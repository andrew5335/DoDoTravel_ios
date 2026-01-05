//
//  User.swift
//  DoDoTravel
//
//  사용자 모델
//

import Foundation

struct User: Codable {
    let id: String
    let username: String
    let email: String
    var profileImageURL: String?
    var nickname: String?
    var phoneNumber: String?
    
    init(id: String, username: String, email: String, profileImageURL: String? = nil, nickname: String? = nil, phoneNumber: String? = nil) {
        self.id = id
        self.username = username
        self.email = email
        self.profileImageURL = profileImageURL
        self.nickname = nickname
        self.phoneNumber = phoneNumber
    }
}

