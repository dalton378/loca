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
}
