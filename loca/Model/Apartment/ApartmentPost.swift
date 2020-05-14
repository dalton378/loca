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
    
}
