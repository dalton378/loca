//
//  RouterProtocol.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire

protocol ServicesApiRouterProtocol: Router {}

extension ServicesApiRouterProtocol {
    
    var baseURL: URL {
        return AppConfig.shared.ApiBaseUrl
    }
    
    var urlSuffix: String {
        return AppConfig.shared.ServicesApiUrlSuffix
    }
    
    func asURLRequest() throws -> URLRequest {
        
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/\(urlSuffix)/\(path)"
        
        if queryString != nil {
            urlComponents?.query = queryString
        }
        
        let url = urlComponents?.url
        var urlRequest = URLRequest(url: url!)
        
        //    var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        for (headerField, value) in headers ?? [:] {
            urlRequest.setValue(value, forHTTPHeaderField: headerField)
        }
        
        return try encoding.encode(urlRequest, with: parameters)
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .post:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }
}
