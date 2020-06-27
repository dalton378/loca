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
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ApartmentApiProtocol.getApartment(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getApartmentDetail(id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ApartmentApiProtocol.getApartmentDetail(id: id, token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getPropertyType(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ApartmentApiProtocol.getPropertyType(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getProvinces(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ProvinceAPIProtocol.getProvinces(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getDistrictByProvince(id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
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
    
    func changeUserPassword(pass: String, newPass: String, confirmPass: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(AccountApiProtocol.changePass(token: token, pass: pass, newPass: newPass, confirmedPass: confirmPass))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func forgetPassword(email: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(AccountApiProtocol.forgetPass(email: email))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func register(name: String, email: String, phone: String, pass: String, passConfirm: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(AccountApiProtocol.register(name: name, phone: phone, email: email, pass: pass, passConfirm: passConfirm))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func postFile(file: UIImage, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let photoString = file.base64String
        session.request(ApartmentApiProtocol.postFiles(data: photoString))
        .validate()
        .responseString(completionHandler: completionHandler)
    }
    
    func searchApartment(token: String, post_type_id: String, min_price: String, min_currency: String, max_price: String, max_currency: String, property_type_id: String, province_id : String, district_id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(ApartmentApiProtocol.searchApartment(token: token, post_type_id: post_type_id, min_price: min_price, min_currency: min_currency, max_price: max_price, max_currency: max_currency, property_type_id: property_type_id, province_id: province_id, district_id: district_id))
        .validate()
        .responseString(completionHandler: completionHandler)
    }
    
    func createPost(data: ApartmentPostCreation, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        guard let token = AppConfig.shared.accessToken else {return}
        session.request(ApartmentApiProtocol.createPost(token: token, data: data))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getWardByDistrict(id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(ProvinceAPIProtocol.getWardByDisctrict(id: id))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getCurrencies(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ProvinceAPIProtocol.getCurrencies(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getAreaUnit(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ProvinceAPIProtocol.getAreaUnit(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getTransactionType(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ProvinceAPIProtocol.getTransactionType(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getFBUserId(token: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(FBApiProtocol.getFBUserId(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func getPost(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ApartmentApiProtocol.getPost(token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func socialLogin(name: String, id: String, provider: String, email: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(AccountApiProtocol.socialLogin(name: name, id: id, provider: provider, email: email))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func phoneVerify(token: String, id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        session.request(AccountApiProtocol.phoneVerify(id: id, token: token))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func requestToken(completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let id = AppConfig.shared.profileId ?? 0
        session.request(AccountApiProtocol.requestToken(id: id))
            .validate()
            .responseString(completionHandler: completionHandler)
    }
    
    func deletePost(id: String, completionHandler: @escaping (AFDataResponse<String>) -> Void ) {
        let token = AppConfig.shared.accessToken ?? ""
        session.request(ApartmentApiProtocol.deletePost(token: token, id: id))
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
