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
    
    @IBOutlet weak var resendPINButton: UIButton!
    
    let store = AlamofireStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    private func setupUI(){
        setEmptyBackButton()
        
        pinView.pinLength = 5
        pinView.secureCharacter = "\u{25CF}"
        pinView.interSpace = 15
        pinView.textColor = UIColor.init(named: "UBlack")!
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
            let id = AppConfig.shared.profileId ?? 0
            self.store.phoneVerify(token: pin, id: String(id), completionHandler: {result in
                switch result{
                case .success:
                    Messages.displaySuccessMessage(message: "Xác nhận tài khoản thành công!")
                    sharedFunctions.getUserInfo {
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                case .failure:
                    Messages.displayErrorMessage(message: "Xác nhận tài khoản không thành công!")
                }
            })
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.resendPINButton.isEnabled = true
        })
    }
    
    
    @IBAction func resendPIN(_ sender: UIButton) {
        store.requestToken(completionHandler: {result in
            switch result{
            case .success:
                Messages.displaySuccessMessage(message: "PIN gửi thành công!")
            case .failure:
                Messages.displayErrorMessage(message: "PIN gửi không thành công. Vui lòng thử lại sau")
            }
        })
    }
    
    @IBAction func toHome(_ sender: UITapGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}
