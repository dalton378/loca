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
}
