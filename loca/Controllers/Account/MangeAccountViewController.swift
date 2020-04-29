//
//  MangeAccountViewController.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class MangeAccountViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = AppConfig.shared.profileName
        phoneLabel.text = AppConfig.shared.profilePhone
        emailLabel.text = AppConfig.shared.profileEmail
    }
    

   
}
