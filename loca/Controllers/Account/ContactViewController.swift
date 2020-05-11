//
//  ContactViewController.swift
//  loca
//
//  Created by Dalton on 5/11/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ContactViewController: UIViewController {

    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var topicTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
    }
    
    private func prepareUI() {
        setEmptyBackButton()
        FloatingTextField.configureFloatingText(textfield: nameTextField, placeHolder: "Tên", title: "Tên")
        FloatingTextField.configureFloatingText(textfield: phoneTextField, placeHolder: "Số điện thoại", title: "Số điện thoại")
        FloatingTextField.configureFloatingText(textfield: emailTextField, placeHolder: "Email", title: "Email")
         FloatingTextField.configureFloatingText(textfield: topicTextField , placeHolder: "Chủ đề", title: "Chủ đề")
        
        
    }
    
}
