//
//  VerifyPhoneViewController.swift
//  loca
//
//  Created by Dalton on 6/9/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SVPinView

class VerifyPhoneViewController: UIViewController {
    
    @IBOutlet weak var pinView: SVPinView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI(){
        setEmptyBackButton()
        
        pinView.pinLength = 5
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 15
        pinView.textColor = UIColor.black
        pinView.shouldSecureText = true
        pinView.style = .box
        
        pinView.borderLineColor = UIColor.init(named: "UBlack")!
        pinView.activeBorderLineColor = UIColor.init(named: "UCyan")!
        pinView.borderLineThickness = 1
        pinView.activeBorderLineThickness = 3
        pinView.fieldCornerRadius = 10
        pinView.activeFieldCornerRadius = 10
        
        pinView.font = UIFont.systemFont(ofSize: 25)
        pinView.keyboardType = .phonePad
        pinView.becomeFirstResponderAtIndex = 0
        
        pinView.didFinishCallback = { pin in
            print("The pin entered is \(pin)")
        }
    }
    @IBAction func toHome(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
