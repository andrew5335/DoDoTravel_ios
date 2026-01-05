//
//  MainViewController.swift
//  DoDoTravel
//
//  메인 화면 - Tab Bar Controller
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let touristVC = TouristListViewController()
        touristVC.tabBarItem = UITabBarItem(
            title: "관광지",
            image: UIImage(systemName: "map"),
            selectedImage: UIImage(systemName: "map.fill")
        )

        let accommodationVC = AccommodationListViewController()
        accommodationVC.tabBarItem = UITabBarItem(
            title: "숙박",
            image: UIImage(systemName: "bed.double"),
            selectedImage: UIImage(systemName: "bed.double.fill")
        )

        let restaurantVC = RestaurantListViewController()
        restaurantVC.tabBarItem = UITabBarItem(
            title: "맛집",
            image: UIImage(systemName: "fork.knife"),
            selectedImage: UIImage(systemName: "fork.knife")
        )

        let recommendationVC = RecommendationViewController()
        recommendationVC.tabBarItem = UITabBarItem(
            title: "추천",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )

        viewControllers = [
            UINavigationController(rootViewController: touristVC),
            UINavigationController(rootViewController: accommodationVC),
            UINavigationController(rootViewController: restaurantVC),
            UINavigationController(rootViewController: recommendationVC)
        ]
    }
}
