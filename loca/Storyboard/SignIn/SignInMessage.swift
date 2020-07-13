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
import SkyFloatingLabelTextField
import TransitionButton

class SignInMessage: MessageView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonSign: TransitionButton!
    @IBOutlet weak var phoneTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var passwordTextfield: SkyFloatingLabelTextField!
    
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var FBLoginView: UIView!
    @IBOutlet weak var GGLoginView: UIView!
    
    @IBOutlet weak var GGSignInButton: UIView!
    
    @IBOutlet weak var SingupButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var doneAction: (() -> Void)?
    var exitAction: (() -> Void)?
    var openSignUpAction: (() -> Void)?
    var forgotPass: (() -> Void)?
    var ggSignInAction: (() -> Void)?
    var fbSignInAction: (() -> Void)?
    
    let store = AlamofireStore()
    
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
        
        FloatingTextField.configureFloatingText(textfield: passwordTextfield, placeHolder: "Password", title: "Password")
        passwordTextfield.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        
        FloatingTextField.configureFloatingText(textfield: phoneTextfield, placeHolder: "Số điện thoại", title: "Số điện thoại")
        phoneTextfield.addTarget(self, action: #selector(self.validateInput(_:)), for: .editingChanged)
        phoneTextfield.keyboardType = .phonePad
        
        TransitionButtonCustom.configureTransitionButton(button: buttonSign, tittle: "Đăng Nhập", tapHandler: nil)
        
        SingupButton.layer.cornerRadius = 10
        contentView.layer.cornerRadius = 20
        GGSignInButton.layer.cornerRadius = 10
        GGLoginView.layer.cornerRadius = 10
        FBLoginView.layer.cornerRadius = 10
        
        let loginButton = FBLoginButton()
        loginButton.layer.cornerRadius = 10
        subViewFixinContainer(FBLoginView, button: loginButton)
        
        NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            
            // Print out access token
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
            
            guard let token = AccessToken.current?.tokenString else {return}
            
            self.store.getFBUserId(token: token, completionHandler: {(result) in
                switch result {
                case .success(let data):
                    let parsedData = data.data(using: .utf8)
                    guard let newData = parsedData, let autParams = try? JSONDecoder().decode(SocialMediaApiModel.self, from: newData) else {return}
                    self.store.socialLogin(name: autParams.name, id: autParams.id, provider: "Facebook", email: "", completionHandler: {result in
                        switch result {
                        case .success(let data):
                            let parsedData = data.data(using: .utf8)
                            guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else { return}
                            AppConfig.shared.accessToken = autParams.access_token
                            AppConfig.shared.isSignedIn = true
                            self.exitAction?()
                            Messages.displaySuccessMessage(message: "Đăng Nhập Thành Công.")
                            self.fbSignInAction?()
                        case .failure:
                            return
                        }
                    })
                case .failure:
                    return
                }
                
                print(result)
            })
            
        }
    }
    
    private func signIn(password: String, phone: String) {
        buttonSign.startAnimation()
        self.errorMessageLabel.isHidden = true
        let store = AlamofireStore()
        store.login(email: "", password: password, phone: phone, completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else {
                    self.buttonSign.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {
                        self.errorMessageLabel.isHidden = false})
                    return
                }
                AppConfig.shared.accessToken = autParams.access_token
                AppConfig.shared.isSignedIn = true
                self.buttonSign.stopAnimation(animationStyle: .expand, revertAfterDelay: 1, completion: {
                    self.exitAction?()
                    Messages.displaySuccessMessage(message: "Đăng Nhập Thành Công.")
                    self.doneAction?()
                })
                
            case .failure:
                
                self.buttonSign.stopAnimation(animationStyle: .shake, revertAfterDelay: 1, completion: {
                    self.errorMessageLabel.isHidden = false})
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
    
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.endEditing(true)
    }
    
    private func subViewFixinContainer(_ container: UIView!, button: UIControl) -> Void{
        button.translatesAutoresizingMaskIntoConstraints = false;
        button.frame = container.frame;
        container.addSubview(button);
        NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    @IBAction func ggSignInAction(_ sender: UIButton) {
        ggSignInAction!()
        exitAction!()
    }
    
    @objc func validateInput(_ textfield: SkyFloatingLabelTextField) {
        let validation = TextValidation()
        if let text = textfield.text {
            var result: ResultTextValidation?
            if textfield == passwordTextfield {
                result = validation.validateByRule(rules: [.empty], text: text)
                
            } else if textfield == phoneTextfield {
                result = validation.validateByRule(rules: [.empty, .phone], text: text)
            }
            guard let _ = result?.isFailed else{
                textfield.errorMessage = ""
                return }
            
            textfield.errorMessage = result?.message
        }
    }
}
