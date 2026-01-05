//
//  DestinationCell.swift
//  DoDoTravel
//
//  목적지 목록 셀
//

import UIKit

class DestinationCell: UITableViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true
    }

    func configure(with destination: Destination) {
        nameLabel.text = destination.name
        addressLabel.text = destination.address ?? ""
        
        if let rating = destination.rating {
            let reviewCount = destination.reviewCount ?? 0
            ratingLabel.text = String(format: "%.1f (%d)", rating, reviewCount)
        } else {
            ratingLabel.text = ""
        }

        // 이미지 로드
        if let imageUrl = destination.imageUrl, let url = URL(string: imageUrl) {
            // TODO: 이미지 로딩 (SDWebImage 또는 Kingfisher 사용)
            // thumbnailImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}

