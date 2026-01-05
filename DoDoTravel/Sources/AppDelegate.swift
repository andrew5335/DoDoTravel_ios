//
//  AppDelegate.swift
//  DoDoTravel
//
//  Created on 2024
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Google Maps API Key 설정
        // Info.plist에서 GMSApiKey를 읽어오거나 직접 설정
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let apiKey = plist["GMSApiKey"] as? String {
            GMSServices.provideAPIKey(apiKey)
        } else {
            // 직접 API Key 설정 (개발용)
            GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

