//
//  ApartmentDetailViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/2/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class ApartmentDetailViewController: UIViewController {

    var apartmentId: String?
    
    let store = AlamofireStore()
    override func viewDidLoad() {
        super.viewDidLoad()

        getApartmentDetail(id: apartmentId!)
    }
    

    private func getApartmentDetail(id: String) {
        store.getApartmentDetail(id: id, completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentDetail.self, from: newData) else {return}
                print(autParams)
            case .failure:
                return
            }
        })
    }
    

}
