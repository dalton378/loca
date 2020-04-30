//
//  SignUpCustomView.swift
//  loca
//
//  Created by Toan Nguyen on 4/30/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class SignUpCustomView: UIView {

    
    @IBOutlet weak var lsbel: UILabel!
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("SignUp", owner: self, options: nil)
            //contentView.fixInView(self)
        }
    }
