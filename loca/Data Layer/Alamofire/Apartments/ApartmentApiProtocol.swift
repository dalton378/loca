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
    case getPropertyType(token: String)
    case postFiles(data: String)
    case searchApartment(token: String, post_type_id: String?, min_price: String?, min_currency: String?, max_price: String?, max_currency: String?, property_type_id: String?, province_id : String?, district_id: String?)
    
    var method: HTTPMethod {
        switch self {
        case .getApartment, .getApartmentDetail, .getPropertyType, .searchApartment:
            return .get
        case .postFiles:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getApartment:
            return "apartments"
        case .getApartmentDetail( let id, _):
            return "apartments/\(id)"
        case .getPropertyType:
            return "property-type"
        case .postFiles:
            return "files"
        case .searchApartment:
            return "apartments"
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getApartment, .getApartmentDetail, .getPropertyType, .searchApartment:
            return URLEncoding.default
        case .postFiles:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .postFiles(let data):
            return ["file": data]
        case .searchApartment(_, let post_type_id, let min_price, let min_currency, let max_price, let max_currency, let property_type_id, let province_id, let district_id):
            var parameters = [String: String]()
            if !post_type_id!.isEmpty{
                parameters.updateValue(post_type_id!, forKey: "post_type_id")
            }
            if !min_price!.isEmpty{
                parameters.updateValue(min_price!, forKey: "min_price")
            }
            if !min_currency!.isEmpty{
                parameters.updateValue(min_currency!, forKey: "min_currency")
            }
            if !max_price!.isEmpty{
                parameters.updateValue(max_price!, forKey: "max_price")
            }
            if !min_price!.isEmpty{
                parameters.updateValue(min_price!, forKey: "min_price")
            }
            if !max_currency!.isEmpty{
                parameters.updateValue(max_currency!, forKey: "max_currency")
            }
            if !property_type_id!.isEmpty{
                parameters.updateValue(property_type_id!, forKey: "property_type_id")
            }
            if !province_id!.isEmpty{
                parameters.updateValue(province_id!, forKey: "province_id")
            }
            if !district_id!.isEmpty{
                parameters.updateValue(district_id!, forKey: "district_id")
            }
            
            return parameters
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getApartment(token), .getApartmentDetail(_, let token), .getPropertyType(let token), .searchApartment(let token,_,_,_,_,_,_,_,_):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
