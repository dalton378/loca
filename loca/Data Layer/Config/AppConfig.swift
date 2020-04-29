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
    
    private var userDefaults: UserDefaults {
        #if DEBUG
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil {
            return UserDefaults.init(suiteName: "XcodeTest")!
        } else {
            return UserDefaults.standard
        }
        #else
        return UserDefaults.standard
        #endif
    }
    
    
    var networkTimeout: TimeInterval {
        return 60
    }
    
    var ApiBaseUrl: URL {
        return URL.init(string: "https://area51.localoca.vn")!
    }
    
    var ServicesApiUrlSuffix: String {
        return "v1"
    }
    
    var accessToken: String? {
          get { return userDefaults.string(forKey: "token") }
          set { userDefaults.set(newValue, forKey: "token") }
      }
    
    var profileEmail: String? {
        get { return userDefaults.string(forKey: "profileEmail") }
        set { userDefaults.set(newValue, forKey: "profileEmail") }
    }
    
    var profilePhone: String? {
        get { return userDefaults.string(forKey: "profilePhone") }
        set { userDefaults.set(newValue, forKey: "profilePhone") }
    }
    
    var profileName: String? {
        get { return userDefaults.string(forKey: "profileName") }
        set { userDefaults.set(newValue, forKey: "profileName") }
    }
    
    var profileId: Int? {
        get { return userDefaults.integer(forKey: "profileId") }
        set { userDefaults.set(newValue, forKey: "profileId") }
    }
    
    var profilePhoneVerified: Int? {
        get { return userDefaults.integer(forKey: "profilePhoneVerified") }
        set { userDefaults.set(newValue, forKey: "profilePhoneVerified") }
    }
    var profileEmailVerified: Int? {
        get { return userDefaults.integer(forKey: "profileEmailVerified") }
        set { userDefaults.set(newValue, forKey: "profileEmailVerified") }
    }
    
    var isSignedIn: Bool? {
        get { return userDefaults.bool(forKey: "isSignedIn") }
        set { userDefaults.set(newValue, forKey: "isSignedIn") }
    }
}
