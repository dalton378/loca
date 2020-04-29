//
//  Router.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import Alamofire

protocol Router: URLRequestConvertible {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: [String: String]? { get }
    var queryString: String? { get }
}

extension Router {
    
    var parameters: Parameters? {
        return nil
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    var queryString: String? {
        return nil
    }
}
