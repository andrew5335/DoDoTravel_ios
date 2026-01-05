//
//  ReviewManagementViewController.swift
//  DoDoTravel
//
//  리뷰 관리 화면
//

import UIKit

class ReviewManagementViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    private var reviews: [Review] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadReviews()
    }
    
    private func setupUI() {
        title = "리뷰 관리"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        
        emptyLabel.text = "작성한 리뷰가 없습니다."
        emptyLabel.isHidden = true
    }
    
    private func loadReviews() {
        // TODO: 현재 사용자가 작성한 리뷰 목록을 서버에서 가져오기
        // 현재는 빈 배열
        reviews = []
        tableView.reloadData()
        emptyLabel.isHidden = !reviews.isEmpty
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ReviewManagementViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(with: reviews[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let review = reviews[indexPath.row]
            // TODO: 서버에서 리뷰 삭제
            reviews.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            emptyLabel.isHidden = !reviews.isEmpty
        }
    }
}

