//
//  SignInViewController.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    
    
    @IBOutlet weak var phoneTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    
    @IBOutlet weak var FBLoginButton: UIButton!
    @IBOutlet weak var GGLoginButton: UIButton!
    @IBOutlet weak var SingupButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func signIn(_ sender: UIButton) {
        let pass = passwordTextfield.text
        let phone = phoneTextfield.text
        signIn(password: pass!, phone: phone!)
    }
    
    
    private func setupUI() {
        signinButton.layer.cornerRadius = 10
       // signinButton.layer.borderWidth = 1
        //signinButton.layer.borderColor = UIColor.black.cgColor
    }
    
    
    
    private func signIn(password: String, phone: String) {
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
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error.underlyingError ?? "nil")
                Messages.displayErrorMessage(message: "Thông tin đăng nhập không đúng. Vui lòng thử lại sau!")
            }
        })
    }
    
}
