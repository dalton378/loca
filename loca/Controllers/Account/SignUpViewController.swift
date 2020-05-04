//
//  SignUpViewController.swift
//  loca
//
//  Created by Dalton on 5/4/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpView: SignUpCustomView!
    override func viewDidLoad() {
        super.viewDidLoad()

        signUpView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
