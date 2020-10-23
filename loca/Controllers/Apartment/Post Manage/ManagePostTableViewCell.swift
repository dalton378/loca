//
//  ManagePostTableViewCell.swift
//  loca
//
//  Created by Toan Nguyen on 6/26/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import Kingfisher

class ManagePostTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(photo: URL?, address: String, price: String, date: String, status: statusCases) {
        self.photo.kf.setImage(with: photo)
        self.addressLabel.text = address
        self.priceLabel.text = price
        self.dateLabel.text = date
        switch status {
        case .passed:
            self.statusLabel.text = "Hoàn Tất"
            self.statusLabel.textColor = UIColor.green
        case .failed:
            self.statusLabel.text = "Không Hoàn Tất"
            self.statusLabel.textColor = UIColor.red
        default:
            self.statusLabel.text = "Đang Duyệt"
        }
    }
    
    enum statusCases {
        case passed
        case failed
        case pending
    }

}
