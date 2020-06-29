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
    let email: String?
    let phone: String?
    let is_phone_verified: Int
    let is_email_verified: Int
}

struct AccountUpdate {
    var oldValue: String = ""
    var newValue: String = ""
    var title: String {
        switch type {
        case .name:
            return "Tên hiển thị"
        case .phone:
            return "Số điện thoại"
        case .password:
            return "Mật khẩu"
        case .email:
            return "Email"
        }
    }
    
    var successMessage: String {
        switch type {
        case .name:
            return "Cập nhật tên thành công!"
        case .phone:
            return "Cập nhật số điện thoại thành công!"
        case .password:
            return "Cập nhật mật khẩu thành công!"
        case.email:
            return "Cập nhật email thành công!"
        }
    }
    var errorMessage: String {
        switch type {
        case .name:
            return "Cập nhật tên không thành công. Vui lòng thử lại sau!"
        case .password:
             return "Cập nhật mật khẩu không thành công. Vui lòng thử lại sau!"
        case .phone:
             return "Cập nhật số điện thoại không thành công. Vui lòng thử lại sau!"
        case.email :
            return "Cập nhật email không thành công. Vui lòng thử lại sau!"
        }
    }
    var type : UpdateCase
}

enum UpdateCase {
    case name
    case password
    case phone
    case email
}

protocol UpdateAccountData {
    func update(data: String, type: UpdateCase)
}

struct UpdateAccountError: Codable {
    var error: String
}

struct AccountGeneralError: Codable {
    let message: String
    let errors: AccountGeneralErrorDetail
}

struct AccountGeneralErrorDetail: Codable {
    let email: [String]?
    let phone: [String]?
}
