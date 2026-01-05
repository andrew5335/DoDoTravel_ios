//
//  RouteViewController.swift
//  DoDoTravel
//
//  경로 안내 화면
//

import UIKit
import GoogleMaps
import CoreLocation

class RouteViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var transportationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var routeSummaryLabel: UILabel!
    @IBOutlet weak var gasStationsTableView: UITableView!
    @IBOutlet weak var restAreasTableView: UITableView!
    @IBOutlet weak var gasStationsView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var originLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    var destinationName: String = ""

    private var currentRouteInfo: RouteInfo?
    private var gasStations: [GasStation] = []
    private var restAreas: [RestArea] = []
    private var bannerAdView: BannerAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBannerAd()
        setupMap()
        loadRoute(mode: "driving")
    }

    private func setupUI() {
        title = "경로 안내"

        transportationSegmentedControl.setTitle("자동차", forSegmentAt: 0)
        transportationSegmentedControl.setTitle("도보", forSegmentAt: 1)
        transportationSegmentedControl.setTitle("자전거", forSegmentAt: 2)
        transportationSegmentedControl.setTitle("대중교통", forSegmentAt: 3)

        transportationSegmentedControl.addTarget(self, action: #selector(transportationChanged), for: .valueChanged)

        gasStationsTableView.delegate = self
        gasStationsTableView.dataSource = self
        gasStationsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        restAreasTableView.delegate = self
        restAreasTableView.dataSource = self
        restAreasTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupBannerAd() {
        bannerAdView = BannerAdView()
        view.addSubview(bannerAdView)
        bannerAdView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bannerAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bannerAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bannerAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bannerAdView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        bannerAdView.updateRootViewController(self)
    }

    private func setupMap() {
        guard let origin = originLocation else { return }

        let camera = GMSCameraPosition.camera(withLatitude: origin.latitude, longitude: origin.longitude, zoom: 12.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }

    @objc private func transportationChanged() {
        let mode = getCurrentMode()
        loadRoute(mode: mode)
        
        // 자동차 모드일 때만 주유소/휴게소 표시
        gasStationsView.isHidden = (mode != "driving")
        if mode == "driving" {
            loadGasStationsAndRestAreas()
        }
    }

    private func getCurrentMode() -> String {
        switch transportationSegmentedControl.selectedSegmentIndex {
        case 0: return "driving"
        case 1: return "walking"
        case 2: return "bicycling"
        case 3: return "transit"
        default: return "driving"
        }
    }

    private func loadRoute(mode: String) {
        guard let origin = originLocation,
              let destination = destinationLocation else { return }

        activityIndicator.startAnimating()

        // TODO: Google Directions API 호출
        // ApiService.getDirections(
        //     origin: (origin.latitude, origin.longitude),
        //     destination: (destination.latitude, destination.longitude),
        //     mode: mode
        // ) { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.activityIndicator.stopAnimating()
        //         switch result {
        //         case .success(let routeInfo):
        //             self?.currentRouteInfo = routeInfo
        //             self?.updateRouteInfo(routeInfo)
        //             self?.drawRouteOnMap(routeInfo)
        //         case .failure(let error):
        //             print("Error: \(error.localizedDescription)")
        //         }
        //     }
        // }

        activityIndicator.stopAnimating()
    }

    private func updateRouteInfo(_ routeInfo: RouteInfo) {
        durationLabel.text = routeInfo.duration
        distanceLabel.text = routeInfo.distance
        routeSummaryLabel.text = "경로 정보"
    }

    private func drawRouteOnMap(_ routeInfo: RouteInfo) {
        // TODO: Polyline 디코딩 및 지도에 표시
        // let path = GMSPath(fromEncodedPath: routeInfo.polyline)
        // let polyline = GMSPolyline(path: path)
        // polyline.strokeColor = .blue
        // polyline.strokeWidth = 5.0
        // polyline.map = mapView
    }

    private func loadGasStationsAndRestAreas() {
        guard let origin = originLocation,
              let destination = destinationLocation else { return }

        // TODO: API 호출
        // ApiService.searchGasStations(...) { ... }
        // ApiService.searchRestAreas(...) { ... }
    }
}

extension RouteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == gasStationsTableView {
            return gasStations.count
        } else {
            return restAreas.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if tableView == gasStationsTableView {
            cell.textLabel?.text = gasStations[indexPath.row].name
        } else {
            cell.textLabel?.text = restAreas[indexPath.row].name
        }
        
        return cell
    }
}

