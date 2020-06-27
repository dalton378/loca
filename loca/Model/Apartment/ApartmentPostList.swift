//
//  ApartmentPostList.swift
//  loca
//
//  Created by Toan Nguyen on 5/23/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


struct ApartmentPostDetail: Codable {
    var id: Int?
    var track_id: Int
    var post_id: Int?
    var start_date: String
    var post_status: Int?
    var end_date: String
    var project: String?
    var property_type: PropertyTypePost
    var post_type: PostType
    var user_id: Int
    var region: String?
    var address: String
    var province: Province
    var district: District
    var ward: Ward
    var images: [ApartmentPhotos]
    var street: String
    //var apartment_number: String?
    var apartment_code: String?
    var direction: String
    var lat: Double
    var lng: Double
    var area: String
    var area_unit: AreadUnit
    var floor_number: Int?
    var bedroom_number: Int?
    var bathroom_number: Int?
    var rooftop: String?
    // var garden: String?
    //var pool: String?
    var description: String
    var price: String
    var currency: Currency
    var apartment_contacts: [ApartmentContact]?
    var approved_user: Int?
}

struct PropertyTypePost: Codable {
    var id: String
    var name: String
}

struct PostTypePost: Codable {
    var id: String
    var name: String
}

struct ProvincePost: Codable {
    var id: String
    var name: String
}

struct DistrictPost: Codable {
    var id: String
    var name: String
}


struct WardPost: Codable {
    var id: String
    var name: String
}

struct AreadUnitPost: Codable {
    var id: String
    var name: String
}

struct CurrencyPost: Codable {
    var id: String
    var name: String
}


