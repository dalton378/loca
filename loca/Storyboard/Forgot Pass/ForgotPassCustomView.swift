//
//  ForgotPassCustomView.swift
//  loca
//
//  Created by Toan Nguyen on 5/1/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SwiftMessages

class ForgotPassCustomView: MessageView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
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
           contentView.fixInView(self)
       }
    @IBAction func dismiss(_ sender: Any) {
        self.endEditing(true)
    }
    
    @IBAction func submit(_ sender: UIButton) {
        errorLabel.isHidden = true
        let pass = passwordTextField.text!
        let validation = TextValidation()
        let result = validation.validateByRule(rules: [.empty, .emailPattern], text: pass)
        
        guard let _ = result.isFailed else {return}
        errorLabel.text = result.message
        errorLabel.isHidden = false
    }
    
}
