//
//  SignInMessage.swift
//  loca
//
//  Created by Toan Nguyen on 4/30/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SwiftMessages
import FBSDKLoginKit

class SignInMessage: MessageView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonSign: UIButton!
    
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var FBLoginView: UIView!
    @IBOutlet weak var GGLoginView: UIView!
    

    @IBOutlet weak var SingupButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var underlineLabel: UIView!
    
    var doneAction: (() -> Void)?
    var exitAction: (() -> Void)?
    var openSignUpAction: (() -> Void)?
    var forgotPass: (() -> Void)?
    
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
        
            FBLoginView.awakeFromNib()
        //let loginButton = FBLoginButton(frame: CGRect(x: 0 , y: 0, width: underlineLabel.frame.size.width * 0.95, height: FBLoginView.frame.size.height))
         let loginButton = FBLoginButton()
        
        //loginButton.center.x = FBLoginView.center.x
        ButtonfixInView(FBLoginView, button: loginButton)
        //FBLoginView.addSubview(loginButton)
        
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
    }
    
    private func signIn(password: String, phone: String) {
        self.errorMessageLabel.isHidden = true
        let store = AlamofireStore()
            store.login(email: "", password: password, phone: phone, completionHandler: {result in
                switch result {
                case .success(let data):
                    let parsedData = data.data(using: .utf8)
                    guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else {
                        self.errorMessageLabel.isHidden = false
                        return
                    }
                    AppConfig.shared.accessToken = autParams.access_token
                    AppConfig.shared.isSignedIn = true
                    self.exitAction?()
                    Messages.displaySuccessMessage(message: "Đăng Nhập Thành Công.")
                    self.doneAction?()
                case .failure:
                    self.errorMessageLabel.isHidden = false
                }
            })
        }
    
    @IBAction func signUpTrans(_ sender: UIButton) {
        exitAction?()
        openSignUpAction?()
    }
    
    @IBAction func forgotPass(_ sender: UITapGestureRecognizer) {
        exitAction?()
        forgotPass?()
    }
    
    private func ButtonfixInView(_ container: UIView!, button: FBLoginButton) -> Void{
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.frame = container.frame;
        container.addSubview(button);
        NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
}
