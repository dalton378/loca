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
    var ward: SearchDetailWard
    var province: SearchDetailProvince
    var district: SearchDetailDistrict
    var lat: Double?
    var lng: Double?
    var address: String
}

struct SearchDetailWard: Codable {
    var id: Int?
    var name: String?
}

struct SearchDetailProvince: Codable {
    var id: Int?
    var name: String?
}

struct SearchDetailDistrict: Codable {
    var id: Int?
    var name: String?
}


struct SearchAddressList: Codable {
    var data: [SearchAddressItem]?
}

struct SearchAddressItem: Codable {
    var id: Int?
    var search_text: String
}
