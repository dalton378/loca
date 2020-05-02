//
//  ApartmentPreview.swift
//  loca
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class ApartmentPreview: UIView {

   override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
      }
      
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          commonInit()
      }
      
      func commonInit() {
          Bundle.main.loadNibNamed("ForgotPass", owner: self, options: nil)
         // contentView.fixInView(self)
          //contentView.layer.cornerRadius = 20
      }

}
