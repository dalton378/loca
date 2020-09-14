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
    
    func resizeImage(image: UIImage, percent: CGFloat) -> UIImage {
        let size = image.size
        
        let newSize = CGSize(width: size.width * percent, height: size.height * percent)

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? UIImage()
    }
    
    func resizeImageToMB(image: UIImage, size: Int, completionHandler: @escaping ((UIImage) -> ())) {
        let compressionPercent = 0.6
        let newImage = image.resizeImage(image: image, percent: CGFloat(compressionPercent))
        let _size = newImage.pngData()?.count ?? 0
        
        if _size > size {
            resizeImageToMB(image: newImage, size: size, completionHandler: completionHandler)
        } else {
            completionHandler(newImage)
        }
    }
    
   
}
