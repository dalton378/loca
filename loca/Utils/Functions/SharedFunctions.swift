//
//  SharedFunctions.swift
//  loca
//
//  Created by Dalton on 6/29/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn
import MapKit

public class sharedFunctions {
    static func downloadImage(from url: URL) -> UIImage  {
        guard let data = try? Data(contentsOf: url) else {return UIImage()}
        guard let photo = UIImage(data: data) else {return UIImage()}
        return photo
    }
    
    static func downloadLocaApartmentImage(image: ApartmentPhotos) -> UIImage{
        let newString = image.img.replacingOccurrences(of: "\\", with: "", options: .literal, range: nil)
        let data1 = newString.data(using: .utf8)
        let newData = data1!
        let autParams = try? JSONDecoder().decode(ApartmentPhotoDetail.self, from: newData)
        
        let urlString = "\(AppConfig.shared.ApiBaseUrl)/\( autParams!.thumbnail)"
        let urlPhoto = URL(string: urlString)
        
        return self.downloadImage(from: urlPhoto!)
    }
    
    static func getUserInfo(completionHandler: @escaping ()->Void){
        let store = AlamofireStore()
        store.getUser(completionHandler: {result in
            switch result {
            case .success(let data):
                let parsedData = data.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ProfileModel.self, from: newData) else {return}
                AppConfig.shared.profileName = autParams.name
                AppConfig.shared.profileId = autParams.id
                AppConfig.shared.profileEmail = autParams.email
                AppConfig.shared.profilePhone = autParams.phone
                AppConfig.shared.profileEmailVerified = autParams.is_email_verified
                AppConfig.shared.profilePhoneVerified = autParams.is_phone_verified
                completionHandler()
            case .failure:
                return
            }
        })
    }
    
    static func signOut(completionHandler: @escaping () -> Void){
        let loginManager = LoginManager()
        loginManager.logOut()
        GIDSignIn.sharedInstance().signOut()
        AppConfig().resetDefaults()
        completionHandler()
    }
    
    static func imageWith(name: String?) -> UIImage? {
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let nameLabel = UILabel(frame: frame)
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .lightGray
        nameLabel.textColor = .white
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        var initials = ""
        if let initialsArray = name?.components(separatedBy: " ") {
            if let firstWord = initialsArray.first {
                if let firstLetter = firstWord.first {
                    initials += String(firstLetter).capitalized }
            }
            if initialsArray.count > 1, let lastWord = initialsArray.last {
                if let lastLetter = lastWord.first { initials += String(lastLetter).capitalized
                }
            }
        } else {
            return nil
        }
        nameLabel.text = initials
        UIGraphicsBeginImageContext(frame.size)
        if let currentContext = UIGraphicsGetCurrentContext() {
            nameLabel.layer.render(in: currentContext)
            let nameImage = UIGraphicsGetImageFromCurrentImageContext()
            return nameImage
        }
        return nil
    }
    
    static func getAddressFromLatLon(coordinate: CLLocationCoordinate2D) -> (city: String?, ward: String?, street: String?)   {
            let center = coordinate
            let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
            var result = CLPlacemark()
        
            ceo.reverseGeocodeLocation(loc, completionHandler:
                {(placemarks, error) in
                    if (error != nil)
                    {
                        print("reverse geodcode fail: \(error!.localizedDescription)")
                    }
                    let pm = placemarks! as [CLPlacemark]

                    if pm.count > 0 {
                        let pm = placemarks![0]
                        result = pm
//                        print(pm.country)
//                        print(pm.locality)
//                        print(pm.subLocality)
//                        print(pm.thoroughfare)
//                        print(pm.postalCode)
//                        print(pm.subThoroughfare)
                       
                  }
                    //return (result.locality, result.subLocality, result.thoroughfare)
            })
        //completionHandler(result.locality, result.subLocality, result.thoroughfare)
        if ((result.locality?.isEmpty) != nil){
            return ("","","")
        } else {
        return (result.locality, result.subLocality, result.thoroughfare)
        }
    }
}
