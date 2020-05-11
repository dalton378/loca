//
//  PosCreationContactViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/7/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class PosCreationContactViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: PostCreationContactProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()

        setEmptyBackButton()
        confirmButton.layer.cornerRadius = 10
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.getContact(name: emailTextField.text!, phone: phoneTextField.text!, email: emailTextField.text!)
    }
}

protocol PostCreationContactProtocol {
    func getContact(name: String, phone: String, email: String)
}
