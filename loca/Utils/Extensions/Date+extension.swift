//
//  Date+extension.swift
//  Finstro
//
//  Created by Erick Vavretchek on 12/6/19.
//  Copyright © 2019 Finstro. All rights reserved.
//

import Foundation

extension Date {
    var monthSpelledOut: String {
        return self.toString(withDateFormat: "MMMM")
    }
    
    var year: String {
        return self.toString(withDateFormat: "yyyy")
    }
    
    var dayOrdinal: String {
        let day = self.toString(withDateFormat: "d")
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        return numberFormatter.string(from: NSNumber(value: Int(day)!))!
    }
    
    func toString(withDateFormat dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
