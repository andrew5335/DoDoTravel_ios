//
//  ReviewCell.swift
//  DoDoTravel
//
//  리뷰 셀
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!

    func configure(with review: Review) {
        userNameLabel.text = review.userName
        dateLabel.text = review.date
        ratingLabel.text = String(format: "%.1f", review.rating)
        commentLabel.text = review.comment
    }
}

