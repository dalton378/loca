//
//  AlamofireRequest.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire

class AlamofireRequest {
    let session = NetworkSessionManager.shared.sessionManager
    func login2(email: String, password: String, phone: String, completionHandler: @escaping (DataResponse<Data?, AFError>) -> Void ) {
        
        session.request(AccountApiProtocol.login(email: email, phone: phone, password: password))
            .validate()
            .responseDecodable(completionHandler: completionHandler)
    }
    
    func login(email: String, password: String, phone: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        
        session.request(AccountApiProtocol.login(email: email, phone: phone, password: password))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getUser(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(AccountApiProtocol.getUser(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getApartment(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(ApartmentApiProtocol.getApartment(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getApartmentDetail(id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(ApartmentApiProtocol.getApartmentDetail(id: id, token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getPropertyType(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(ApartmentApiProtocol.getPropertyType(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getProvinces(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(ProvinceAPIProtocol.getProvinces(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getDistrictByProvince(id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(ProvinceAPIProtocol.getDistrictByProvince(id: id, token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func updateAccountName(name: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
           guard let token = AppConfig.shared.accessToken else {return}
        session.request(AccountApiProtocol.updateName(token: token, name: name))
               .validate()
               .responseString(completionHandler: completionHandler)
       }
    
    func updateAccountPhone(phone: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(AccountApiProtocol.updatePhone(token: token, phone: phone))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func updateAccountEmail(email: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(AccountApiProtocol.updateEmail(token: token, email: email))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
}


class NetworkSessionManager {
    static let shared = NetworkSessionManager()
    
    //    static var serverTrustPolicies: [String: ServerTrustPolicy]!
    let sessionManager: Session = {
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = AppConfig.shared.networkTimeout
        configuration.timeoutIntervalForResource = AppConfig.shared.networkTimeout
        
        
        let session = Session(configuration: configuration)
        return session
    }()
}
