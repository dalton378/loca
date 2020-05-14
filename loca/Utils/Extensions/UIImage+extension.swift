//
//  UIImage+extension.swift
//  Finstro
//
//  Created by Dalton Nguyen on 5/14/20.
//  Copyright © 2019 Finstro. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var base64String: String {
        let imageData = jpegData(compressionQuality: 0.2)! as NSData
        return imageData.base64EncodedString()
    }
}
