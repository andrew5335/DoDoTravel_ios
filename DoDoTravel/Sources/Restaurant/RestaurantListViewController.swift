//
//  RestaurantListViewController.swift
//  DoDoTravel
//
//  맛집 목록 화면
//

import UIKit

class RestaurantListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var destinations: [Destination] = []
    private var bannerAdView: BannerAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBannerAd()
        loadRestaurants()
    }

    private func setupUI() {
        title = "맛집"
        navigationController?.navigationBar.prefersLargeTitles = true

        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력하세요"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellReuseIdentifier: "DestinationCell")

        activityIndicator.hidesWhenStopped = true
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

    private func loadRestaurants() {
        activityIndicator.startAnimating()
        // TODO: API 호출
        activityIndicator.stopAnimating()
    }

    private func searchRestaurants(keyword: String) {
        activityIndicator.startAnimating()
        // TODO: API 호출
        activityIndicator.stopAnimating()
    }
}

extension RestaurantListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let keyword = searchBar.text, !keyword.isEmpty {
            searchRestaurants(keyword: keyword)
        }
    }
}

extension RestaurantListViewController: UITableViewDataSource, UITableViewDelegate {
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

