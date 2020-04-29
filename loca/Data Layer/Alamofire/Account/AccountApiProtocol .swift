//
//  AccountApiProtocol .swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire


enum AccountApiProtocol: ServicesApiRouterProtocol {
    
    case login(email: String, phone: String, password: String)
    case getUser(token: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUser:
            return .get
            
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .getUser:
            return "auth/user"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login:
            return JSONEncoding.default
        case .getUser:
            return URLEncoding.default
        }
        
    }
    
    var parameters: Parameters? {
        switch self {
        case let .login(email, phone, password):
            return [
                "email": email,
                "password": password,
                "phone": phone
            ]
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getUser(token):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
