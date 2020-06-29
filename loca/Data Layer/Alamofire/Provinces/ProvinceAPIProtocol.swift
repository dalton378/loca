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
    case getWardByDisctrict(id: String)
    case getCurrencies(token: String)
    case getAreaUnit(token: String)
    case getTransactionType(token: String)
    
    var method: HTTPMethod {
        switch self {
        case .getProvinces, .getDistrictByProvince, .getPropertyType, .getWardByDisctrict, .getCurrencies, .getAreaUnit, .getTransactionType:
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
        case .getWardByDisctrict(let id):
            return "wards/\(id)"
        case .getCurrencies:
            return "commons/currencies"
        case .getAreaUnit:
            return "commons/area-units"
        case .getTransactionType:
            return "post-types"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getProvinces, .getDistrictByProvince, .getPropertyType, .getWardByDisctrict, .getCurrencies, .getAreaUnit, .getTransactionType:
            return URLEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
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
