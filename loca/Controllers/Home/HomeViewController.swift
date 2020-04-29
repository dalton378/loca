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
        let store = AlamofireStore()
        /*
        store.login(email: "mecamyeu2001@yahoo.com", password: "P@ssw0rd2020", phone: "0909499240", completionHandler: {result in

            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                 guard let newData = parsedData, let autParams = try? JSONDecoder().decode(AccountModel.self, from: newData) else {
                    Messages.displayErrorMessage(message: "Không thể tải dữ liệu. Vui lòng thử lại sau!")
                    return
                }
                
                print(autParams.access_token)
            case .failure(let error):
                print(error.underlyingError ?? "nil")
                Messages.displayErrorMessage(message: "Không thể tải dữ liệu. Vui lòng thử lại sau!")
            }
        })*/
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
