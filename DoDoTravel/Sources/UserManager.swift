//
//  UserManager.swift
//  DoDoTravel
//
//  사용자 로그인 상태 관리
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    private let userDefaults = UserDefaults.standard
    private let currentUserKey = "currentUser"
    private let isLoggedInKey = "isLoggedIn"
    
    private(set) var currentUser: User?
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    private init() {
        loadUser()
    }
    
    /// 사용자 로그인
    func login(username: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // TODO: 실제 서버 API 호출로 변경
        // 현재는 로컬 저장소에서 확인 (테스트용)
        if let savedUsers = userDefaults.dictionary(forKey: "registeredUsers") as? [String: [String: String]] {
            if let userData = savedUsers[username],
               let savedPassword = userData["password"],
               savedPassword == password {
                // 로그인 성공
                let user = User(
                    id: userData["id"] ?? UUID().uuidString,
                    username: username,
                    email: userData["email"] ?? "",
                    profileImageURL: userData["profileImageURL"],
                    nickname: userData["nickname"],
                    phoneNumber: userData["phoneNumber"]
                )
                saveUser(user)
                completion(true, nil)
                return
            }
        }
        
        // 로그인 실패
        completion(false, "아이디 또는 비밀번호가 올바르지 않습니다.")
    }
    
    /// 사용자 회원가입
    func signUp(username: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        // TODO: 실제 서버 API 호출로 변경
        
        // 중복 체크
        var savedUsers = userDefaults.dictionary(forKey: "registeredUsers") as? [String: [String: String]] ?? [:]
        
        if savedUsers[username] != nil {
            completion(false, "이미 존재하는 아이디입니다.")
            return
        }
        
        // 새 사용자 저장
        let userId = UUID().uuidString
        savedUsers[username] = [
            "id": userId,
            "email": email,
            "password": password,
            "profileImageURL": "",
            "nickname": "",
            "phoneNumber": ""
        ]
        userDefaults.set(savedUsers, forKey: "registeredUsers")
        
        // 자동 로그인
        let user = User(id: userId, username: username, email: email)
        saveUser(user)
        completion(true, nil)
    }
    
    /// 사용자 정보 업데이트
    func updateUser(_ user: User) {
        saveUser(user)
        
        // 저장된 사용자 정보도 업데이트
        var savedUsers = userDefaults.dictionary(forKey: "registeredUsers") as? [String: [String: String]] ?? [:]
        if var userData = savedUsers[user.username] {
            userData["email"] = user.email
            userData["profileImageURL"] = user.profileImageURL ?? ""
            userData["nickname"] = user.nickname ?? ""
            userData["phoneNumber"] = user.phoneNumber ?? ""
            savedUsers[user.username] = userData
            userDefaults.set(savedUsers, forKey: "registeredUsers")
        }
    }
    
    /// 로그아웃
    func logout() {
        currentUser = nil
        userDefaults.removeObject(forKey: currentUserKey)
        userDefaults.set(false, forKey: isLoggedInKey)
    }
    
    /// 사용자 정보 저장
    private func saveUser(_ user: User) {
        currentUser = user
        if let encoded = try? JSONEncoder().encode(user) {
            userDefaults.set(encoded, forKey: currentUserKey)
            userDefaults.set(true, forKey: isLoggedInKey)
        }
    }
    
    /// 저장된 사용자 정보 로드
    private func loadUser() {
        if let data = userDefaults.data(forKey: currentUserKey),
           let user = try? JSONDecoder().decode(User.self, from: data) {
            currentUser = user
        }
    }
}

