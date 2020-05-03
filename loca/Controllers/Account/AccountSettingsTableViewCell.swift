//
//  AccountSettingsTableViewCell.swift
//  loca
//
//  Created by Toan Nguyen on 5/3/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class AccountSettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var iconPhoto: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(icon: UIImage, description: String) {
        iconPhoto.image = icon
        descriptionLabel.text = description
    }

}
