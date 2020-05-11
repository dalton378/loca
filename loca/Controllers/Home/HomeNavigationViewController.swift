//
//  HomeNavigationViewController.swift
//  loca
//
//  Created by Dalton on 5/11/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class HomeNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        //self.navigationBar.tintColor = UIColor.init(hex: "03A9F3")
        self.navigationController?.view.backgroundColor = .clear
    }
}

