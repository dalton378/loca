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
    var id: String
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
        user_id = "" ; apartment_id = "" ; currency_id = ""; lat = ""; currency_id = "" ;lat = "" ;lng = "" ;address = "" ;name = "" ;street = "" ;content = "" ;ward_id = "" ;total_area = "" ;district_id = "" ;province_id = "" ;apartment_code = "" ;apartment_number = "" ;property_type_id = "" ;post_type_id = "" ;images = [""] ;prices_unit_id = "" ;area = "" ;area_unit_id = "" ;bathroom_number = "" ;bedroom_number = "" ;contacts = [] ;description = "" ;direction = "" ;end_date = "" ;floor_number = "" ;garden = "" ;id = "" ;pool = "" ;price = "" ;region = "" ;start_date = ""; rooftop = ""
    }
    var user_id: String
    var apartment_id : String
    var currency_id: String
    var lat: String
    var lng: String
    var address: String
    var name: String
    var street: String
    var content: String
    var ward_id: String
    var total_area: String
    var district_id: String
    var province_id: String
    var apartment_code: String
    var apartment_number: String
    var property_type_id: String
    var post_type_id: String
    var images: [String]
    var prices_unit_id: String
    var area: String
    var area_unit_id: String
    var bathroom_number: String
    var bedroom_number: String
    var contacts: [ApartmentContact]
    var description: String
    var direction: String
    var end_date: String
    var floor_number: String
    var garden: String
    var id: String
    var pool: String
    var price: String
    var region: String?
    var start_date: String
    var rooftop: String
}


