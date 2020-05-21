//
//  ApartmentModel.swift
//  loca
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation

struct ApartmentList: Codable {
    var total: Int
    var data: [ApartmentInfo]
}

struct ApartmentInfo: Codable {
    var id : Int
    var lat: String
    var lng: String
    var search_text: String
    var post_type: String
    var post_type_id: Int
}

struct CommonAPIReturn: Codable {
    var id: Int
    var name: String
}
