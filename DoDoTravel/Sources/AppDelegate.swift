//
//  AppDelegate.swift
//  DoDoTravel
//
//  Created on 2024
//

import UIKit
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AdMob 초기화
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
           let plist = NSDictionary(contentsOfFile: path),
           let appId = plist["GADApplicationIdentifier"] as? String {
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        } else {
            // 기본값으로 초기화 (실제 App ID는 Info.plist에 설정 필요)
            GADMobileAds.sharedInstance().start(completionHandler: nil)
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

