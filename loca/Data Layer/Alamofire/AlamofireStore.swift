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
    
    func getUser(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getUser(completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getApartments(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getApartment(completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getApartmentDetail(id: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getApartmentDetail(id: id, completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getPropertyType(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getPropertyType(completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getProvinces(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getProvinces(completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getDistrictByProvince(id: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getDistrictByProvince(id: id, completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func updateAccountName(name: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.updateAccountName(name: name, completionHandler: {result in
            print(result.response?.statusCode)
            completionHandler(result.result)
        })
    }
    
    
}
