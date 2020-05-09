//
//  AcountModel.swift
//  loca
//
//  Created by Toan Nguyen on 4/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation

struct AccountModel: Codable {
    let access_token: String
}


struct ProfileModel: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let is_phone_verified: Int
    let is_email_verified: Int
}

protocol UpdateAccountData {
    func update(data: String)
}
