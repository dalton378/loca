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
            completionHandler(result.result)
        })
    }
    
    func updateAccountPhone(phone: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.updateAccountPhone(phone: phone, completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func updateAccountEmail(email: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.updateAccountEmail(email: email, completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func changeAccountPass(pass: String, newPass: String, confirmPass: String, completionHandler: @escaping ((Result<String, AFError>, Data?) -> Void )) {
        client.changeUserPassword(pass: pass, newPass: newPass, confirmPass: confirmPass, completionHandler: {result in
            completionHandler(result.result, result.data)
        })
    }
    
    func forgetPassword(email: String, completionHandler: @escaping ((Result<String, AFError>, Data?) -> Void )) {
        client.forgetPassword(email: email, completionHandler: {result in
            completionHandler(result.result, result.data)
        })
    }
    
    func register(name: String, email: String, phone: String, pass: String, passConfirm: String, completionHandler: @escaping ((Result<String, AFError>, Data?) -> Void )) {
        client.register(name: name, email: email, phone: phone, pass: pass, passConfirm: passConfirm, completionHandler: {result in
            completionHandler(result.result, result.data)
        })
    }
    
    func postFile(file: UIImage, completionHandler: @escaping ((Result<String, AFError>, Data?) -> Void )) {
        client.postFile(file: file, completionHandler: {result in
            
            print(result.description)
            print(result.debugDescription)
            print(result.response?.statusCode)
            print(result.data)
            completionHandler(result.result, result.data)
        })
    }
    
    func searchApartment(token: String, post_type_id: String, min_price: String, min_currency: String, max_price: String, max_currency: String, property_type_id: String, province_id : String, district_id: String, completionHandler:@escaping (Result<String, AFError>) -> Void ) {
           client.searchApartment(token: token, post_type_id: post_type_id, min_price: min_price, min_currency: min_currency, max_price: max_price, max_currency: max_currency, property_type_id: property_type_id, province_id: province_id, district_id: district_id, completionHandler: {result in
            completionHandler(result.result)
           })
       }
    
    func createPost(data: ApartmentPostCreation, completionHandler: @escaping ((Result<String, AFError>, Data?) -> Void )) {
        client.createPost(data: data, completionHandler: {result in
            print(result.response?.statusCode)
            completionHandler(result.result, result.data)
        })
    }
    
    func getWardByDisctrict(id: String, completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getWardByDistrict(id: id, completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getCurrencies(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getCurrencies(completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getAreaUnit(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getAreaUnit(completionHandler: {result in
            completionHandler(result.result)
        })
    }
    
    func getTransactionType(completionHandler: @escaping (Result<String, AFError>) -> Void ) {
        client.getTransactionType(completionHandler: {result in
            print(result.response?.statusCode)
            completionHandler(result.result)
        })
    }
    
}
