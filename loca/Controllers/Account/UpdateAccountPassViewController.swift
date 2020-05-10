//
//  UpdateAccountPassViewController.swift
//  loca
//
//  Created by Dalton on 5/10/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class UpdateAccountPassViewController: UIViewController {
    
    
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var newPassTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var confirmPassTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI(){
        FloatingTextField.configureFloatingText(textfield: passwordTextField, placeHolder: "Nhập Password cũ", title: "Password cũ")
        FloatingTextField.configureFloatingText(textfield: newPassTextField, placeHolder: "Nhập Password mới", title: "Password mới")
        FloatingTextField.configureFloatingText(textfield: confirmPassTextField, placeHolder: "Nhập lại password", title: "Nhập lại password")
    }
    

    @IBAction func confirm(_ sender: UIButton) {
    }
    

}
