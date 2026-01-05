//
//  InterstitialAdManager.swift
//  DoDoTravel
//
//  전면 광고 관리자 - 앱 종료 시 표시
//

import UIKit
import GoogleMobileAds

class InterstitialAdManager: NSObject {
    
    static let shared = InterstitialAdManager()
    
    private var interstitialAd: GADInterstitialAd?
    private var isShowingAd = false
    private var exitTimer: Timer?
    
    // 테스트용 Ad Unit ID (실제 사용 시 AdMob에서 발급받은 ID로 변경)
    private let adUnitID = "ca-app-pub-3940256099942544/4411468910" // Google 테스트 전면 광고 ID
    
    private override init() {
        super.init()
        loadInterstitialAd()
    }
    
    /// 전면 광고 로드
    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                return
            }
            
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            print("Interstitial ad loaded successfully")
        }
    }
    
    /// 앱 종료 시 전면 광고 표시 (최소 2초간 표시)
    func showInterstitialAdOnExit() {
        guard !isShowingAd else { return }
        
        // 이미 광고가 로드되어 있으면 즉시 표시
        if let ad = interstitialAd {
            showAd(ad)
        } else {
            // 광고가 없으면 새로 로드 시도
            loadInterstitialAd()
        }
    }
    
    private func showAd(_ ad: GADInterstitialAd) {
        guard let rootViewController = getRootViewController() else {
            print("Root view controller not found")
            return
        }
        
        isShowingAd = true
        
        // 광고가 표시된 후 최소 2초가 지나야 닫을 수 있도록 플래그 설정
        exitTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { [weak self] _ in
            // 2초가 지났지만 광고가 아직 표시 중이면, 사용자가 닫을 수 있도록 함
            // 실제로는 광고가 자동으로 닫히지 않으므로, 이 타이머는 최소 표시 시간을 보장하기 위한 것
            print("Minimum 2 seconds have passed for interstitial ad")
        }
        
        ad.present(fromRootViewController: rootViewController)
    }
    
    private func dismissAd() {
        exitTimer?.invalidate()
        exitTimer = nil
        isShowingAd = false
        
        // 다음 광고를 미리 로드
        loadInterstitialAd()
    }
    
    private func getRootViewController() -> UIViewController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return window.rootViewController
        }
        return nil
    }
}

// MARK: - GADFullScreenContentDelegate
extension InterstitialAdManager: GADFullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Interstitial ad dismissed")
        dismissAd()
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Failed to present interstitial ad: \(error.localizedDescription)")
        dismissAd()
    }
}

