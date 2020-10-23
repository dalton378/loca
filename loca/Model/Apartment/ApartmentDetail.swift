//
//  ApartmentDetail.swift
//  loca
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


struct ApartmentDetail: Codable {
    var id: Int
    var track_id: Int
    var post_id: Int?
    var start_date: String
    var post_status: Int?
    var end_date: String
    var project: String?
    var property_type: PropertyType
    var post_type: PostType
    var user_id: Int
    var region: String?
    var address: String
    var province: Province
    var district: District
    var ward: Ward
    var images: [ApartmentPhotos]
    var street: String
    var apartment_number: String?
    var apartment_code: String?
    var direction: String?
    var lat: String
    var lng: String
    var area: Int
    var area_unit: AreadUnit
    var floor_number: Int?
    var bedroom_number: Int?
    var bathroom_number: Int?
    var rooftop: Int?
    var garden: Int?
    var pool: Int?
    var description: String
    var price: Int
    var currency: Currency
    var apartment_contacts: [ApartmentContact]
}


struct PropertyType: Codable {
    var id: Int
    var name: String
}

struct PostType: Codable {
    var id: Int
    var name: String
}

struct Province: Codable {
    var id: Int
    var name: String
}

struct District: Codable {
    var id: Int
    var name: String
}

struct ProvinceList: Codable {
    var data : [Province]
}

struct DistrictList: Codable {
    var data : [District]
}


struct Ward: Codable {
    var id: Int
    var name: String
}

struct ApartmentPhotos: Codable {
    var id: Int
    var img: String
    var alt: String
}

struct AreadUnit: Codable {
    var id: Int
    var name: String
}

struct Currency: Codable {
    var id: Int
    var name: String
}

struct ApartmentContact: Codable {
    var name: String?
    var phone: String?
    var email: String?
}

struct ApartmentPhotoDetail: Codable {
    var original: String
    var thumbnail: String
}

struct ApartmentPostList: Codable {
    var current_page: Int
    var data: [ApartmentPostDetail]
    var total: Int
}

struct GetApartmentPostList: Codable {
    var current_page: Int
    var data: [ApartmentPostDetail]
    var total: Int
}
