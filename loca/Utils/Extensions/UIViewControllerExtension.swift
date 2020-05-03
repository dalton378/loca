//
//  UIViewControllerExtension.swift
//  loca
//
//  Created by Toan Nguyen on 5/3/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setEmptyBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    func setTransparentNavigationBar(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.init(hex: "03A9F3")
    }
}
