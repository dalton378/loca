//
//  PostCreationCameraCollectionViewCell.swift
//  loca
//
//  Created by Toan Nguyen on 5/7/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class PostCreationCameraCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    func setPhoto(photo: UIImage) {
        self.photo.image = photo
    }
}
