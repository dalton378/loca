//
//  GoogleSigninViewController.swift
//  loca
//
//  Created by Dalton on 6/4/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import GoogleSignIn

class GoogleSigninViewController: UIViewController, GIDSignInDelegate {
    let googleSignIn = GIDSignIn.sharedInstance()
    var store = AlamofireStore()
    
    var getData: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleSignIn?.presentingViewController = self 
        self.googleSignIn?.clientID = "924891718499-2f8cd1tvcql7b24v6o3qngl8hm2567iv.apps.googleusercontent.com"
        self.googleSignIn?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.googleSignIn?.signIn()
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
           
           if (error == nil) {
               // Perform any operations on signed in user here.
               let userId = user.userID                  // For client-side use only!
               //let idToken = user.authentication.idToken // Safe to send to the server
               let fullName = user.profile.name
              // let givenName = user.profile.givenName
             //  let familyName = user.profile.familyName
               let email = user.profile.email
            store.socialLogin(name: fullName ?? "", id: userId ?? "", provider: "Google", email: email ?? "", completionHandler: {result in
                switch result {
                case .success(let data):
                    let parsedData = data.data(using: .utf8)
                    guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else { return}
                    AppConfig.shared.accessToken = autParams.access_token
                    AppConfig.shared.isSignedIn = true
                    Messages.displaySuccessMessage(message: "Đăng Nhập Thành Công.")
                    sharedFunctions.getUserInfo(completionHandler: {
                        guard let _ = AppConfig.shared.profilePhone else {
                            self.performSegue(withIdentifier: "google_phonenumber", sender: self)
                            return
                        }
                        self.navigationController?.popToRootViewController(animated: true)
                    })
                case .failure:
                    return
                }
            })
            
           } else {
               print("\(error.localizedDescription)")
           }
       }
}
