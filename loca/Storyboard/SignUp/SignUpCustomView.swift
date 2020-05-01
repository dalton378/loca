//
//  SignUpCustomView.swift
//  loca
//
//  Created by Toan Nguyen on 4/30/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SwiftMessages

class SignUpCustomView: MessageView {
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
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
        contentView.fixInView(self)
    }
    
    @IBAction func signUp(_ sender: UIButton) {
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
}
