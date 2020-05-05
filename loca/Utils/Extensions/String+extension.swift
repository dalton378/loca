//
//  String+extension.swift
//  Finstro
//
//  Created by Erick Vavretchek on 14/5/19.
//  Copyright © 2019 Finstro. All rights reserved.
//

import Foundation

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
    
    /// Will convert dd/MM/yyyy to Date
    var toDate: Date {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df.date(from: self)!
    }
    
    var isAlphanumeric: Bool {
        return self.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil && self != ""
    }
    
    var isNumeric: Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func toDateWith(format: String) -> Date {
        let df = DateFormatter()
        df.dateFormat = format
        let returnDate = df.date(from: self)
        guard returnDate != nil else {
            fatalError("Cannot convert string: \(self) to date using format: \(format)")
        }
        return returnDate!
    }
    
    func toDictionary() -> NSDictionary {
        let blankDict : NSDictionary = [:]
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return blankDict
    }
    
    func validateEmailPattern() -> Bool {
        self.matches("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    func validatePhonePattern() -> Bool {
        self.matches("^[0-9+]{0,1}+[0-9]{5,16}$")
    }

    private func matches(_ regex: String) -> Bool {
        let pattern = NSPredicate(format: "SELF MATCHES %@", regex)
        return pattern.evaluate(with: self)
    }
} 
