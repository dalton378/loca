//
//  AddressDetailSearch.swift
//  loca
//
//  Created by Toan Nguyen on 8/5/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


struct AddressDetailSearch: Codable {
    var street: String?
    var street_number: Int?
    var apartment_number: Int?
    var ward: Ward
    var province: Province
    var district: District
}
