//
//  AccommodationListViewController.swift
//  DoDoTravel
//
//  숙박 목록 화면
//

import UIKit

class AccommodationListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    private var destinations: [Destination] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAccommodations()
    }

    private func setupUI() {
        title = "숙박"
        navigationController?.navigationBar.prefersLargeTitles = true

        searchBar.delegate = self
        searchBar.placeholder = "검색어를 입력하세요"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "DestinationCell", bundle: nil), forCellReuseIdentifier: "DestinationCell")

        activityIndicator.hidesWhenStopped = true
    }

    private func loadAccommodations() {
        activityIndicator.startAnimating()
        // TODO: API 호출
        activityIndicator.stopAnimating()
    }

    private func searchAccommodations(keyword: String) {
        activityIndicator.startAnimating()
        // TODO: API 호출
        activityIndicator.stopAnimating()
    }
}

extension AccommodationListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let keyword = searchBar.text, !keyword.isEmpty {
            searchAccommodations(keyword: keyword)
        }
    }
}

extension AccommodationListViewController: UITableViewDataSource, UITableViewDelegate {
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

