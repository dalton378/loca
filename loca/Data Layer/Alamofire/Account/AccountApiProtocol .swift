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
    case updateName(token: String, name: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getUser:
            return .get
        case .updateName:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .getUser:
            return "auth/user"
        case .updateName:
            return "auth/update"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login,.updateName:
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
        case let .updateName(_, name):
            return ["name": name]
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getUser(token), let .updateName(token,_):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
