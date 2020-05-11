//
//  UITextViewExtension.swift
//  loca
//
//  Created by Dalton on 5/11/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit

private var __maxLengths = [UITextView: Int]()
extension UITextView: UITextViewDelegate {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            delegate = self
           // addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextView) {
        if let t = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        fix(textField: self)
    }
}
