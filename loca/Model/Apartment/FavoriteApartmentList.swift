//
//  FavoriteApartmentList.swift
//  loca
//
//  Created by Toan Nguyen on 7/26/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation


struct FavoriteApartmentList: Codable {
    var total: Int
    var data: [FavoriteApartment]?
}

struct FavoriteApartment: Codable {
    var id: Int
    var apartment : FavoriteApartmentDetail
}

struct FavoriteApartmentDetail: Codable {
    var id: Int
}
