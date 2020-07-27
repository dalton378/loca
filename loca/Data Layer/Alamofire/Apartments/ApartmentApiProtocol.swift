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
    case postFiles( data: String)
    case searchApartment(token: String, post_type_id: String?, min_price: String?, min_currency: String?, max_price: String?, max_currency: String?, property_type_id: String?, province_id : String?, district_id: String?)
    case createPost(token: String, data: ApartmentPostCreation)
    case getPost(token: String)
    case deletePost(token: String, id: String)
    case updatePost(token:String, data: ApartmentPostCreation)
    case addFavorte(apartmentId: String, token: String)
    case getFavoriteList(token: String)
    case deleteFavorite(id: String, token: String)
    
    var method: HTTPMethod {
        switch self {
        case .getApartment, .getApartmentDetail, .getPropertyType, .searchApartment, .getPost, .getFavoriteList:
            return .get
        case .postFiles, .createPost, .addFavorte:
            return .post
        case .deletePost, .deleteFavorite:
            return .delete
        case .updatePost:
            return .put
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
        case .createPost:
            return "post-apartments"
        case .getPost:
            return "post-apartments"
        case .deletePost(_,let id):
            return "post-apartments/\(id)"
        case .updatePost(_,let data):
            return "post-apartments/\(data.track_id ?? 0)"
        case .addFavorte:
            return "favourite-apartments"
        case .getFavoriteList:
            return "favourite-apartments"
        case .deleteFavorite(let id,_):
            return "favourite-apartments/\(id)"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getApartment, .getApartmentDetail, .getPropertyType, .searchApartment, .getPost, .deletePost, .getFavoriteList, .deleteFavorite:
            return URLEncoding.default
        case .postFiles, .createPost, .updatePost, .addFavorte:
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
            
        case .createPost(_, let data):
            return [ "apartment_id" : data.apartment_id, "currency_id" : data.currency_id, "lat": data.lat, "lng" : data.lng, "address" : data.address, "name" :data.name, "street" : data.street, "content" : data.content, "ward_id" : data.ward_id, "total_area": data.total_area, "district_id" : data.district_id, "province_id" : data.province_id, "apartment_code" :data.apartment_code, "apartment_number" : data.apartment_number, "property_type_id" : data.property_type_id, "post_type_id" : data.post_type_id, "images": data.images, "area" : data.area, "area_unit_id" :data.area_unit_id, "bathroom_number" : data.bathroom_number, "bedroom_number" :data.bedroom_number, "contacts" : [["name": data.contacts.first!.name, "phone" :data.contacts.first!.phone, "email": data.contacts.first!.email]], "description" : data.description, "direction" : data.direction, "end_date": data.end_date, "floor_number" : data.floor_number, "garden" : data.garden, "pool" :data.pool, "price" : data.price, "region" :data.region ?? "", "start_date": data.start_date, "rooftop" : data.rooftop
            ]
            case .updatePost(_, let data):
            return [ "apartment_id" : data.apartment_id, "currency_id" : data.currency_id, "lat": data.lat, "lng" : data.lng, "address" : data.address, "name" :data.name, "street" : data.street, "content" : data.content, "ward_id" : data.ward_id, "total_area": data.total_area, "district_id" : data.district_id, "province_id" : data.province_id, "apartment_code" :data.apartment_code, "apartment_number" : data.apartment_number, "property_type_id" : data.property_type_id, "post_type_id" : data.post_type_id, "images": data.images, "area" : data.area, "area_unit_id" :data.area_unit_id, "bathroom_number" : data.bathroom_number, "bedroom_number" :data.bedroom_number, "contacts" : [["name": data.contacts.first!.name, "phone" :data.contacts.first!.phone, "email": data.contacts.first!.email]], "description" : data.description, "direction" : data.direction, "end_date": data.end_date, "floor_number" : data.floor_number, "garden" : data.garden, "pool" :data.pool, "price" : data.price, "region" :data.region ?? "", "start_date": data.start_date, "rooftop" : data.rooftop
            ]
        case .addFavorte(let apartmentID,_):
            return ["apartment_id" : apartmentID]
        default:
            return [:]
        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getApartment(token), .getApartmentDetail(_, let token), .getPropertyType(let token), .searchApartment(let token,_,_,_,_,_,_,_,_), .createPost(let token, _), .getPost(let token), .deletePost(let token, _), .updatePost(let token, _), .addFavorte(_, let token), .getFavoriteList(let token), .deleteFavorite(_, let token):
            return ["Authorization": "Bearer \(token)"]
        default:
            return [:]
        }
    }
}
