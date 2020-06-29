//
//  SharedFunctions.swift
//  loca
//
//  Created by Dalton on 6/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit

public class sharedFunctions {
    static func downloadImage(from url: URL) -> UIImage  {
        guard let data = try? Data(contentsOf: url) else {return UIImage()}
        guard let photo = UIImage(data: data) else {return UIImage()}
        return photo
    }
    
    static func downloadLocaApartmentImage(image: ApartmentPhotos) -> UIImage{
        let newString = image.img.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let data1 = newString.data(using: .utf8)
        let newData = data1!
        let autParams = try? JSONDecoder().decode(ApartmentPhotoDetail.self, from: newData)
        
        let urlString = "\(AppConfig.shared.ApiBaseUrl)/\( autParams!.thumbnail)"
        let urlPhoto = URL(string: urlString)
        
        return self.downloadImage(from: urlPhoto!)
    }
}
