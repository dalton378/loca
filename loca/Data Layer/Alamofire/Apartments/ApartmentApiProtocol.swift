//
//  ApartmentApiProtocol.swift
//  loca
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire

enum ApartmentApiProtocol: ServicesApiRouterProtocol {
    
    case getApartment(token: String)
    case getApartmentDetail(id: String, token: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .getApartment, .getApartmentDetail:
            return .get
            
        }
    }
    
    var path: String {
        switch self {
        case .getApartment:
            return "apartments"
        case .getApartmentDetail( let id, _):
            return "apartments/\(id)"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getApartment, .getApartmentDetail:
            return URLEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
//        case let .login(email, phone, password):
//            return [
//                "email": email,
//                "password": password,
//                "phone": phone
//            ]
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getApartment(token), .getApartmentDetail(_, let token):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
