//
//  APCustomView.swift
//  test
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Toan Nguyen. All rights reserved.
//

import UIKit

class APCustomView: UIView {

    @IBOutlet var contentVui: UIView!
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var des: UILabel!
    
    
    override init(frame: CGRect) {
           super.init(frame: frame)
           commonInit()
       }
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
           commonInit()
       }
       
       func commonInit() {
           Bundle.main.loadNibNamed("APCustomView", owner: self, options: nil)
          contentVui.fixInView(self)
       }
    
    func setData(photo: UIImage, text: String) {
        icon.image = photo
        des.text = text
    }

}
