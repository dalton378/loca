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
    
    var method: HTTPMethod {
        switch self {
        case .getApartment, .getApartmentDetail, .getPropertyType:
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
        default:
            return ""
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getApartment, .getApartmentDetail, .getPropertyType:
            return URLEncoding.default
        case .postFiles:
            return JSONEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .postFiles(let data):
            return ["file": data]
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getApartment(token), .getApartmentDetail(_, let token), .getPropertyType(let token):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
