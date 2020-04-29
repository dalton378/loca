//
//  AlamofireStore.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireStore {
    let client = AlamofireRequest()
    func login(email: String, password: String, phone: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.login(email: email, password: password, phone: phone, completionHandler: { response in
            print(response.response!.statusCode)
            completionHandler(response.result)
        })
        
    }
}
