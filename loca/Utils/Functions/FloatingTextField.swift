//
//  FloatingTextField.swift
//  loca
//
//  Created by Toan Nguyen on 5/8/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import SkyFloatingLabelTextField

class FloatingTextField {
    
    static func configureFloatingText(textfield: SkyFloatingLabelTextField, placeHolder: String, title: String){
        textfield.placeholder = placeHolder
        textfield.title = title
        textfield.errorColor = UIColor.red
        textfield.textColor = UIColor.init(named: "UBlack")
        textfield.titleColor = UIColor.init(named: "UBlack")!
        textfield.tintColor = UIColor.init(named: "UBlack")
        textfield.selectedLineColor = UIColor.init(named: "UBlack")!
        textfield.selectedTitleColor = UIColor.init(named: "UBlack")!
        textfield.placeholderColor = UIColor.init(named: "UBlack")!
        textfield.lineColor = UIColor.darkGray
        
    }
    
}
