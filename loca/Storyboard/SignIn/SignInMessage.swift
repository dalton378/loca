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
import GoogleSignIn

class SignInMessage: MessageView, GIDSignInDelegate {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var buttonSign: UIButton!
    
    @IBOutlet weak var phoneTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var FBLoginView: UIView!
    @IBOutlet weak var GGLoginView: UIView!
    
    @IBOutlet weak var GGSignInButton: UIView!
    
    @IBOutlet weak var SingupButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var underlineLabel: UIView!
    @IBOutlet weak var passwordLabel: UIView!
    @IBOutlet weak var phoneUnderLineLabel: UIView!
    
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
        passwordLabel.backgroundColor = UIColor.init(hex: "B0B0B0")
        phoneUnderLineLabel.backgroundColor = UIColor.init(hex: "B0B0B0")
        let pass = passwordTextfield.text
        let phone = phoneTextfield.text
        signIn(password: pass!, phone: phone!)
    }
    
    private func setupUI() {
        buttonSign.layer.cornerRadius = 10
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
            
        }
        
//        let googleSignIn = GIDSignInButton()
//        googleSignIn.layer.cornerRadius = 10
//        subViewFixinContainer(GGLoginView, button: googleSignIn)
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
                        self.passwordLabel.backgroundColor = UIColor.red
                        self.phoneUnderLineLabel.backgroundColor = UIColor.red
                        return
                    }
                    AppConfig.shared.accessToken = autParams.access_token
                    AppConfig.shared.isSignedIn = true
                    self.exitAction?()
                    Messages.displaySuccessMessage(message: "Đăng Nhập Thành Công.")
                    self.doneAction?()
                case .failure:
                    self.errorMessageLabel.isHidden = false
                    self.passwordLabel.backgroundColor = UIColor.red
                    self.phoneUnderLineLabel.backgroundColor = UIColor.red
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
    
    
    //MARK:Google SignIn Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        // myActivityIndicator.stopAnimating()
    }
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        //self.present(viewController, animated: true, completion: nil)
       // navigat
    }

    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        //self.dismiss(animated: true, completion: nil)
    }

    //completed sign In
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {

        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    @IBAction func ggSignInAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().delegate=self
        //GIDSignIn.sharedInstance().uiDelegate=self
    }
}
