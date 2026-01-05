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
        delegate = self
        setupTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showLoginIfNeeded()
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
        
        // My Page는 로그인 상태에 따라 다르게 표시
        let myPageVC = MyPageViewController()
        myPageVC.tabBarItem = UITabBarItem(
            title: "My Page",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            UINavigationController(rootViewController: touristVC),
            UINavigationController(rootViewController: accommodationVC),
            UINavigationController(rootViewController: restaurantVC),
            UINavigationController(rootViewController: recommendationVC),
            UINavigationController(rootViewController: myPageVC)
        ]
    }
    
    /// 로그인이 필요하면 로그인 화면 표시
    func showLoginIfNeeded() {
        // My Page 탭이 선택되었고 로그인이 안 되어 있으면 로그인 화면 표시
        if selectedIndex == 4 && !UserManager.shared.isLoggedIn {
            showLoginScreen()
        }
    }
    
    private func showLoginScreen() {
        let loginVC = LoginViewController()
        loginVC.onLoginSuccess = { [weak self] in
            // 로그인 성공 시 My Page로 이동
            self?.selectedIndex = 4
        }
        let navController = UINavigationController(rootViewController: loginVC)
        present(navController, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // My Page 탭 선택 시 로그인 확인
        if let navController = viewController as? UINavigationController,
           navController.viewControllers.first is MyPageViewController {
            if !UserManager.shared.isLoggedIn {
                // 로그인 안 되어 있으면 로그인 화면 표시
                showLoginScreen()
                return false // 탭 전환 방지
            }
        }
        return true
    }
}
