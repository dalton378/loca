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
