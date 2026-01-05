//
//  DetailViewController.swift
//  DoDoTravel
//
//  목적지 상세 화면
//

import UIKit
import CoreLocation

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var openHoursLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var routeButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var reviewsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var destination: Destination?
    private var reviews: [Review] = []
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadDetail()
        loadReviews()
    }

    private func setupUI() {
        title = destination?.name ?? "상세 정보"
        navigationController?.navigationBar.prefersLargeTitles = false

        routeButton.setTitle("경로 안내", for: .normal)
        reviewButton.setTitle("리뷰 작성", for: .normal)
        recommendButton.setTitle("추천하기", for: .normal)

        routeButton.addTarget(self, action: #selector(routeButtonTapped), for: .touchUpInside)
        reviewButton.addTarget(self, action: #selector(reviewButtonTapped), for: .touchUpInside)
        recommendButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)

        reviewsTableView.delegate = self
        reviewsTableView.dataSource = self
        reviewsTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")

        activityIndicator.hidesWhenStopped = true
    }

    private func loadDetail() {
        guard let destination = destination else { return }

        nameLabel.text = destination.name
        addressLabel.text = destination.address ?? ""
        phoneLabel.text = destination.phone ?? ""
        openHoursLabel.text = destination.openHours ?? ""
        descriptionLabel.text = destination.description ?? ""

        // TODO: 이미지 로드
    }

    private func loadReviews() {
        guard let destinationId = destination?.id else { return }
        activityIndicator.startAnimating()

        // TODO: API 호출
        // ApiService.getReviews(destinationId: destinationId) { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.activityIndicator.stopAnimating()
        //         switch result {
        //         case .success(let reviews):
        //             self?.reviews = reviews
        //             self?.reviewsTableView.reloadData()
        //         case .failure(let error):
        //             print("Error: \(error.localizedDescription)")
        //         }
        //     }
        // }
        activityIndicator.stopAnimating()
    }

    @objc private func routeButtonTapped() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    @objc private func reviewButtonTapped() {
        // TODO: 리뷰 작성 다이얼로그 표시
        let alert = UIAlertController(title: "리뷰 작성", message: "리뷰 작성 기능 구현 예정", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    @objc private func recommendButtonTapped() {
        // TODO: 추천 기능 구현
        let alert = UIAlertController(title: "추천하기", message: "추천 기능 구현 예정", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension DetailViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()

        guard let currentLocation = locations.last,
              let destination = destination else { return }

        let routeVC = RouteViewController()
        routeVC.originLocation = currentLocation.coordinate
        routeVC.destinationLocation = CLLocationCoordinate2D(
            latitude: destination.latitude,
            longitude: destination.longitude
        )
        routeVC.destinationName = destination.name

        navigationController?.pushViewController(routeVC, animated: true)
    }
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(with: reviews[indexPath.row])
        return cell
    }
}

