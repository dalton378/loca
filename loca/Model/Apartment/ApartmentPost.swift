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
