//
//  RecommendationViewController.swift
//  DoDoTravel
//
//  관광지 추천 화면
//

import UIKit
import CoreLocation

class RecommendationViewController: UIViewController {

    @IBOutlet weak var getRecommendationsButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var emptyLabel: UILabel!

    private var destinations: [Destination] = []
    private let locationManager = CLLocationManager()
    private var bannerAdView: BannerAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBannerAd()
    }

    private func setupUI() {
        title = "추천"
        navigationController?.navigationBar.prefersLargeTitles = true

        getRecommendationsButton.setTitle("추천 받기", for: .normal)
        getRecommendationsButton.addTarget(self, action: #selector(getRecommendationsButtonTapped), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellReuseIdentifier: "DestinationCell")

        activityIndicator.hidesWhenStopped = true
        emptyLabel.text = "추천 관광지가 없습니다.\n위 버튼을 눌러 추천을 받아보세요."
    }
    
    private func setupBannerAd() {
        bannerAdView = BannerAdView()
        view.addSubview(bannerAdView)
        bannerAdView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint: NSLayoutConstraint
        if let tabBarController = tabBarController {
            bottomConstraint = bannerAdView.bottomAnchor.constraint(equalTo: tabBarController.tabBar.topAnchor)
        } else {
            bottomConstraint = bannerAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        }
        
        NSLayoutConstraint.activate([
            bannerAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint,
            bannerAdView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        tableView.contentInset.bottom = 50
        tableView.scrollIndicatorInsets.bottom = 50
        
        bannerAdView.updateRootViewController(self)
    }

    @objc private func getRecommendationsButtonTapped() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    private func loadRecommendations(latitude: Double, longitude: Double) {
        activityIndicator.startAnimating()
        emptyLabel.isHidden = true

        // TODO: API 호출
        // ApiService.getRecommendations(latitude: latitude, longitude: longitude) { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.activityIndicator.stopAnimating()
        //         switch result {
        //         case .success(let destinations):
        //             self?.destinations = destinations
        //             self?.tableView.reloadData()
        //             self?.emptyLabel.isHidden = !destinations.isEmpty
        //         case .failure(let error):
        //             print("Error: \(error.localizedDescription)")
        //             self?.emptyLabel.isHidden = false
        //         }
        //     }
        // }

        activityIndicator.stopAnimating()
    }
}

extension RecommendationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()

        guard let location = locations.last else { return }
        loadRecommendations(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

extension RecommendationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return destinations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        cell.configure(with: destinations[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let destination = destinations[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.destination = destination
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

