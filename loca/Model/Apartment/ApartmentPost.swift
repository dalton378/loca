//
//  ApartmentPost.swift
//  loca
//
//  Created by Toan Nguyen on 5/5/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation

struct ApartmentPost: Codable {
    var position: PostPosition
}

struct PostPosition: Codable {
    var long: String
    var lat: String
}

struct ApartmentPhotoReturn: Codable{
    var id: Int
    var path: ApartmentPhotoDetailReturn
}

struct ApartmentPhotoDetailReturn: Codable {
    var original: String
    var thumbnail: String
}

struct PhotosBase64Upload: Codable {
    let base64Image: String
}

struct ApartmentPostCreation: Codable {
    
    init() {
        user_id = "" ; apartment_id = "" ; currency_id = 0; lat = 0.0; currency_id = 0 ;lng = 0.0 ;address = "" ;name = "" ;street = "" ;content = "" ;ward_id = 0 ;total_area = "" ;district_id = 0 ;province_id = 0 ;apartment_code = "" ;apartment_number = 0 ;property_type_id = "" ;post_type_id = 0 ;images = [] ;prices_unit_id = "" ;area = "" ;area_unit_id = 0 ;bathroom_number = 0 ;bedroom_number = 0 ;contacts = [ApartmentContact(name: "", phone: "", email: "")] ;description = "" ;direction = "" ;end_date = "" ;floor_number = 0 ;garden = "" ;id = "" ;pool = "" ;price = "" ;region = "" ;start_date = ""; rooftop = ""
    }
    var user_id: String
    var apartment_id : String
    var currency_id: Int
    var lat: Double
    var lng: Double
    var address: String
    var name: String
    var street: String
    var content: String
    var ward_id: Int
    var total_area: String
    var district_id: Int
    var province_id: Int
    var apartment_code: String
    var apartment_number: Int
    var property_type_id: String
    var post_type_id: Int
    var images: [Int]
    var prices_unit_id: String
    var area: String
    var area_unit_id: Int
    var bathroom_number: Int
    var bedroom_number: Int
    var contacts: [ApartmentContact]
    var description: String
    var direction: String
    var end_date: String
    var floor_number: Int
    var garden: String
    var id: String
    var pool: String
    var price: String
    var region: String?
    var start_date: String
    var rooftop: String
}


