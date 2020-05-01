//
//  HomeViewController.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard  let token = AppConfig.shared.accessToken else {
            return
        }
        print(token)
        getUser()
    }
    
    
    @IBAction func accountClick(_ sender: UIButton) {
        
        guard let isSignedIn = AppConfig.shared.isSignedIn else {return}
        switch isSignedIn {
        case true:
            performSegue(withIdentifier: "home_manage", sender: self)
        default:
            Messages.displaySignInMessage(completionHandler: getUser, navigateSignUpAction: {self.performSegue(withIdentifier: "signup_home", sender: self)}, navigateForgotPassAction: {self.performSegue(withIdentifier: "home_forgotPass", sender: self)})
            //Messages.displaySignUpMessage()
        }
        
    }
    
    private func getUser(){
        let store = AlamofireStore()
        store.getUser(completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ProfileModel.self, from: newData) else {return}
                AppConfig.shared.profileName = autParams.name
                AppConfig.shared.profileId = autParams.id
                AppConfig.shared.profileEmail = autParams.email
                AppConfig.shared.profilePhone = autParams.phone
                AppConfig.shared.profileEmailVerified = autParams.is_email_verified
                AppConfig.shared.profilePhoneVerified = autParams.is_phone_verified
                
            case .failure:
                return
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
