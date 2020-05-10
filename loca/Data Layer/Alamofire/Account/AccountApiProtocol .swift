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
    case updatePhone(token: String, phone: String)
    case updateEmail(token: String, email: String)
    case changePass(token: String, pass: String, newPass: String, confirmedPass: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .login, .changePass:
            return .post
        case .getUser:
            return .get
        case .updateName, .updatePhone, .updateEmail:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "auth/login"
        case .getUser:
            return "auth/user"
        case .updateName, .updatePhone, .updateEmail:
            return "auth/update"
        case .changePass:
            return "auth/change-password"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .login,.updateName, .updatePhone, .updateEmail, .changePass:
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
        case let .updatePhone(_, phone):
            return ["phone": phone]
        case let .updateEmail(_, email):
            return ["email": email]
        case let .changePass(_, pass, newPass, confirmedPass):
            return ["current_password": pass,
            "new_password": newPass,
            "new_password_confirmation": confirmedPass]
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getUser(token), let .updateName(token,_), let .updatePhone(token,_), let .updateEmail(token,_), let .changePass(token,  _, _, _):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
