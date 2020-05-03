//
//  ProvinceAPIProtocol.swift
//  loca
//
//  Created by Toan Nguyen on 5/3/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire

enum ProvinceAPIProtocol: ServicesApiRouterProtocol {
    
    case getProvinces(token: String)
    case getDistrictByProvince(id: String, token: String)
    case getPropertyType(token: String)
    
    var method: HTTPMethod {
        switch self {
        case .getProvinces, .getDistrictByProvince, .getPropertyType:
            return .get
            
        }
    }
    
    var path: String {
        switch self {
        case .getProvinces:
            return "provinces"
        case .getDistrictByProvince( let id, _):
            return "districts/\(id)"
        case .getPropertyType:
            return "property-type"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getProvinces, .getDistrictByProvince, .getPropertyType:
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
        case let .getProvinces(token), .getDistrictByProvince(_, let token), .getPropertyType(let token):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
