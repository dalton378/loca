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
    var user_id: Int
    var apartment_id : Int
    var currency_id: Int
    var lat: String
    var lng: String
    var address: String
    var name: String
    var street: String
    var content: String
    var ward_id: Int
    var total_area: Int
    var district_id: Int
    var province_id: Int
    var apartment_code: Int
    var apartment_number: String
    var property_type_id: Int
    var post_type_id: Int
    var images: [Int]
    var prices: Int
}
