//
//  SignInMessage.swift
//  loca
//
//  Created by Toan Nguyen on 4/30/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SwiftMessages

class SignInMessage: MessageView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonSign: UIButton!
    
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var GGLoginButton: UIButton!
    @IBOutlet weak var SingupButton: UIButton!
    
    var doneAction: (() -> Void)?
    
    override init(frame: CGRect) {
          super.init(frame: frame)
          commonInit()
      }
      
      required init?(coder aDecoder: NSCoder) {
          super.init(coder: aDecoder)
          commonInit()
      }
      
      func commonInit() {
        Bundle.main.loadNibNamed("SignIn", owner: self, options: nil)
         contentView.fixInView(self)
        setupUI()
      }
    
    
    @IBAction func signIn(_ sender: UIButton) {
       let pass = passwordTextfield.text
       let phone = phoneTextfield.text
       signIn(password: pass!, phone: phone!)
    }
    
    private func setupUI() {
        buttonSign.layer.cornerRadius = 10
    }
    
    
    
    private func signIn(password: String, phone: String) {
        doneAction?()
        let store = AlamofireStore()
            store.login(email: "", password: password, phone: phone, completionHandler: {result in
                switch result {
                case .success(let data):
                    let parsedData = data.data(using: .utf8)
                    guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else {
                        Messages.displayErrorMessage(message: "Thông tin đăng nhập không đúng. Vui lòng thử lại sau!")
                        return
                    }
                    AppConfig.shared.accessToken = autParams.access_token
                    AppConfig.shared.isSignedIn = true
                   // self.dismiss(animated: true, completion: nil)
                    self.didMoveToSuperview()
                case .failure(let error):
                    print(error.underlyingError ?? "nil")
                    Messages.displayErrorMessage(message: "Thông tin đăng nhập không đúng. Vui lòng thử lại sau!")
                }
            })
        }
    
}
extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
