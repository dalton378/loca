//
//  PostCreationAddInfoViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/6/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import iOSDropDown

class PostCreationAddInfoViewController: UIViewController {
    
    
    @IBOutlet weak var directionDropdown: DropDown!
    @IBOutlet weak var bedroomDropDown: DropDown!
    @IBOutlet weak var floorDropDown: DropDown!
    @IBOutlet weak var bathroomDropDown: DropDown!
    @IBOutlet weak var poolDropDown: DropDown!
    @IBOutlet weak var elevatorDropDown: DropDown!
    @IBOutlet weak var gardenDropDown: DropDown!
    @IBOutlet weak var rooftopDropDown: DropDown!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    private func prepareUI(){
        
        directionDropdown.prepareDropDown(optionArray: ["Đông","Tây","Nam","Bắc","Đông Nam","Đông Bắc", "Tây Nam","Tây Bắc"], idArray: [1,2,3,4,5,6,7,8], completionHandler: {(text,id) in })
        
        var num = [Int]()
        var data = [String]()
        for i in 1...50 {
            num.append(i)
            data.append(String(i) )
        }
        floorDropDown.prepareDropDown(optionArray: data, idArray: num, completionHandler: {(text,id) in })
        bedroomDropDown.prepareDropDown(optionArray: data, idArray: num, completionHandler: {(text,id) in })
        bathroomDropDown.prepareDropDown(optionArray: data, idArray: num, completionHandler: {(text,id) in })
        poolDropDown.prepareDropDown(optionArray: ["Có","Không"], idArray: [1,2], completionHandler: {(text,id) in })
        gardenDropDown.prepareDropDown(optionArray: ["Có","Không"], idArray: [1,2], completionHandler: {(text,id) in })
        rooftopDropDown.prepareDropDown(optionArray: ["Có","Không"], idArray: [1,2], completionHandler: {(text,id) in })
        elevatorDropDown.prepareDropDown(optionArray: ["Có","Không"], idArray: [1,2], completionHandler: {(text,id) in })
        
        
    }
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        switch textField {
//        case directionDropdown:
//            self.directionDropdown.showList()
//        default:
//            break
//        }
//        return false
//    }
    
}
