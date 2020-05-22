//
//  DateTimePicker.swift
//  loca
//
//  Created by Toan Nguyen on 5/22/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit


class DateTimePicker: UIDatePicker {
    
    var view: UIView?
    var textFiled: UITextField?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(view: UIView, textField: UITextField) {
        self.init()
        self.view = view
        self.textFiled = textField
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDatePicker(){
        //Formate Date
        self.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textFiled!.inputAccessoryView = toolbar
        textFiled!.inputView = self
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFiled!.text = formatter.string(from: self.date)
        self.view!.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view!.endEditing(true)
    }
    
    
}
