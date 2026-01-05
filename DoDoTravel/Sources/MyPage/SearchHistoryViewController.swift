//
//  SearchHistoryViewController.swift
//  DoDoTravel
//
//  검색 결과 관리 화면
//

import UIKit

class SearchHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var clearAllButton: UIButton!
    
    private var searchHistory: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSearchHistory()
    }
    
    private func setupUI() {
        title = "검색 결과 관리"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        emptyLabel.text = "검색 기록이 없습니다."
        emptyLabel.isHidden = true
        
        clearAllButton.setTitle("전체 삭제", for: .normal)
        clearAllButton.addTarget(self, action: #selector(clearAllButtonTapped), for: .touchUpInside)
    }
    
    private func loadSearchHistory() {
        // TODO: UserDefaults나 서버에서 검색 기록 가져오기
        if let history = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
            searchHistory = history
        } else {
            searchHistory = []
        }
        tableView.reloadData()
        emptyLabel.isHidden = !searchHistory.isEmpty
    }
    
    @objc private func clearAllButtonTapped() {
        let alert = UIAlertController(title: "전체 삭제", message: "모든 검색 기록을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.searchHistory.removeAll()
            UserDefaults.standard.removeObject(forKey: "searchHistory")
            self?.tableView.reloadData()
            self?.emptyLabel.isHidden = false
        })
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchHistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = searchHistory[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            searchHistory.remove(at: indexPath.row)
            UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
            tableView.deleteRows(at: [indexPath], with: .fade)
            emptyLabel.isHidden = !searchHistory.isEmpty
        }
    }
}

