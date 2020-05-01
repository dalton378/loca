//
//  TextValidation.swift
//  loca
//
//  Created by Toan Nguyen on 5/1/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


class TextValidation {
    
    func validateByRule(rules: [TextValidationType], text: String) -> ResultTextValidation {
        
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
}


enum TextValidationType {
    case empty
    case emailPattern
}

enum resultValidation {
    case isEmptyFailed
    case isEmailFailed
    
}

struct ResultTextValidation {
    var isFailed: resultValidation?
    var message: String {
        switch isFailed {
        case .isEmailFailed:
            return "Email khoong dung format"
        case .isEmptyFailed:
            return "Data khong duoc rong"
        case .none:
            return ""
        }
    }
}
