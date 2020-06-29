//
//  SocialMediaApiProtocol.swift
//  loca
//
//  Created by Toan Nguyen on 5/27/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire


enum FBApiProtocol: Router {
    var baseURL: URL {
        return URL.init(string: "https://graph.facebook.com")!
    }
    
    func asURLRequest() throws -> URLRequest {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        urlComponents?.path = "/\(path)"
        
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
    
    case getFBUserId(token: String)
    
    
    var method: HTTPMethod {
        switch self {
        case .getFBUserId:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getFBUserId:
            return "me"
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getFBUserId:
            return URLEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getFBUserId(let token):
            return ["access_token" : token]

        }
    }
    var headers: [String : String]? {
        switch self {
        case let .getFBUserId(token):
            return ["Authorization": "Bearer \(token)"]
        }
    }
}
