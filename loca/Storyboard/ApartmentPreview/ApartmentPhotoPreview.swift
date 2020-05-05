//
//  ApartmentPhotoPreview.swift
//  loca
//
//  Created by Dalton on 5/5/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class ApartmentPhotoPreview: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ApartmentPreviewPhoto", owner: self, options: nil)
        imageView.fixInView(self)
    }
    
    func setData(photo: UIImage) {
        imageView.image = photo
    }
}
