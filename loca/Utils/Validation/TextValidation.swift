//
//  TextValidation.swift
//  loca
//
//  Created by Toan Nguyen on 5/1/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


class TextValidation {
    
    func validateByRule(rules: [TextValidationType], text: String, confirmText: String? = "") -> ResultTextValidation {
        
        var result = ResultTextValidation.init()
        
        for rule in rules {
            switch rule {
            case .empty:
                if validateEmpty(text: text) {
                    result.isFailed = .isEmptyFailed
                    return result
                }
            case .emailPattern:
                if !validateEmailPattern(text: text) {
                    result.isFailed = .isEmailFailed
                    return result
                }
            case .phone:
                if !validatePhone(text: text) {
                    result.isFailed = .isPhoneFailed
                    return result
                }
            case .confirmPass:
                guard let comparedText = confirmText else {
                    result.isFailed = .isConfirmPassFailed
                    return result
                }
                if !validateConfirmedPass(pass: text, confirmedPass: comparedText) {
                    result.isFailed = .isConfirmPassFailed
                    return result
                }
            }
        }
        return result
    }
    
    
    private func validateEmpty(text: String) -> Bool{
        var result = false
        text.isEmpty == true ? (result = true) : (result = false)
        return result
    }
    
    private func validateEmailPattern(text: String) -> Bool{
           let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
           return emailPred.evaluate(with: text)
       }
    
    private func validatePhone(text: String) -> Bool {
        let PHONE_REGEX = "^[0-9]+$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: text)
        return result
    }
    
    private func validateConfirmedPass(pass: String, confirmedPass: String) -> Bool {
        let result = pass == confirmedPass ? true : false
        return result
    }
}


enum TextValidationType {
    case empty
    case emailPattern
    case phone
    case confirmPass
}

enum resultValidation {
    case isEmptyFailed
    case isEmailFailed
    case isPhoneFailed
    case isConfirmPassFailed
    
}

struct ResultTextValidation {
    var isFailed: resultValidation?
    var message: String {
        switch isFailed {
        case .isEmailFailed:
            return "Email không đúng format"
        case .isEmptyFailed:
            return "Vui lòng điền đủ thông tin"
        case .isPhoneFailed:
            return "Số điện thoại không đúng"
        case .isConfirmPassFailed:
            return "Mật khẩu không trùng khớp"
        case .none:
            return ""
        }
    }
}
