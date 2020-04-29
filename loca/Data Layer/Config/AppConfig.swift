//
//  AppConfig.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


class AppConfig {
    
    static let shared = AppConfig()
    
    var networkTimeout: TimeInterval {
        return 60
    }
    
    var ApiBaseUrl: URL {
        return URL.init(string: "https://area51.localoca.vn")!
    }
    
    var ServicesApiUrlSuffix: String {
        return "v1"
    }
}
