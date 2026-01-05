//
//  SplashViewController.swift
//  DoDoTravel
//
//  Splash 화면
//

import UIKit

class SplashViewController: UIViewController {

    private let splashDelay: TimeInterval = 2.0 // 2 seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Splash 화면 표시 후 Main 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + splashDelay) {
            self.navigateToMain()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBlue
        
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "AppIcon") ?? UIImage(systemName: "map.fill")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        
        let titleLabel = UILabel()
        titleLabel.text = "DoDoTravel"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func navigateToMain() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController ?? MainViewController()
        
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
}

