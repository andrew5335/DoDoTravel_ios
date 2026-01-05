//
//  BannerAdView.swift
//  DoDoTravel
//
//  하단 배너 광고 뷰 컴포넌트
//

import UIKit
import GoogleMobileAds

class BannerAdView: UIView {
    
    private var bannerView: GADBannerView!
    private var adUnitID: String
    
    // 테스트용 Ad Unit ID (실제 사용 시 AdMob에서 발급받은 ID로 변경)
    private static let testAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Google 테스트 배너 광고 ID
    
    init(adUnitID: String? = nil) {
        self.adUnitID = adUnitID ?? BannerAdView.testAdUnitID
        super.init(frame: .zero)
        setupBannerAd()
    }
    
    required init?(coder: NSCoder) {
        self.adUnitID = BannerAdView.testAdUnitID
        super.init(coder: coder)
        setupBannerAd()
    }
    
    private func setupBannerAd() {
        // 배너 광고 크기 설정 (표준 배너)
        let adSize = GADAdSizeBanner
        bannerView = GADBannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID
        bannerView.delegate = self
        
        // 루트 뷰 컨트롤러는 나중에 설정됨 (updateRootViewController에서)
        
        addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 광고 요청
        let request = GADRequest()
        bannerView.load(request)
    }
    
    /// 루트 뷰 컨트롤러 업데이트 (뷰 컨트롤러가 변경될 때 호출)
    func updateRootViewController(_ viewController: UIViewController) {
        bannerView.rootViewController = viewController
    }
}

// MARK: - GADBannerViewDelegate
extension BannerAdView: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Banner ad loaded successfully")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Banner ad failed to load: \(error.localizedDescription)")
    }
}

