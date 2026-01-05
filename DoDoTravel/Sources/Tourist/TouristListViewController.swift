//
//  TouristListViewController.swift
//  DoDoTravel
//
//  관광지 목록 화면
//

import UIKit

class TouristListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var destinations: [Destination] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTouristSpots()
    }

    private func setupUI() {
        title = "관광지"
        navigationController?.navigationBar.prefersLargeTitles = true

        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력하세요"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellReuseIdentifier: "DestinationCell")

        activityIndicator.hidesWhenStopped = true
    }

    private func loadTouristSpots() {
        activityIndicator.startAnimating()
        // TODO: API 호출하여 관광지 목록 가져오기
        // ApiService.searchTouristSpots(keyword: "") { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.activityIndicator.stopAnimating()
        //         switch result {
        //         case .success(let destinations):
        //             self?.destinations = destinations
        //             self?.tableView.reloadData()
        //         case .failure(let error):
        //             print("Error: \(error.localizedDescription)")
        //         }
        //     }
        // }
        activityIndicator.stopAnimating()
    }

    private func searchTouristSpots(keyword: String) {
        activityIndicator.startAnimating()
        // TODO: API 호출하여 검색 수행
        // ApiService.searchTouristSpots(keyword: keyword) { [weak self] result in
        //     DispatchQueue.main.async {
        //         self?.activityIndicator.stopAnimating()
        //         switch result {
        //         case .success(let destinations):
        //             self?.destinations = destinations
        //             self?.tableView.reloadData()
        //         case .failure(let error):
        //             print("Error: \(error.localizedDescription)")
        //         }
        //     }
        // }
        activityIndicator.stopAnimating()
    }
}

// MARK: - UISearchBarDelegate
extension TouristListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let keyword = searchBar.text, !keyword.isEmpty {
            searchTouristSpots(keyword: keyword)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TouristListViewController: UITableViewDataSource, UITableViewDelegate {
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

