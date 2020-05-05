//
//  PostCreationDesViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/5/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class PostCreationDesViewController: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var confirmButton: UIButton!
    var delegate: PostCreationDescritionProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    func setupUI(){
        confirmButton.layer.cornerRadius = 10
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        delegate?.getDescription(description: descriptionTextView.text)
        self.navigationController?.popViewController(animated: true)
    }
}

protocol PostCreationDescritionProtocol {
    func getDescription(description: String)
}
