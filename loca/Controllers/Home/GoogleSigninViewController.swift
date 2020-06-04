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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleSignIn?.presentingViewController = self 
        self.googleSignIn?.clientID = "924891718499-qqmmstqei25je6dqhg2i1tj0v0na658r.apps.googleusercontent.com"
        self.googleSignIn?.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.googleSignIn?.signIn()
    }
    
    
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
}
