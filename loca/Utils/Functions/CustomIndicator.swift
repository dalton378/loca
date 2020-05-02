//
//  CustomIndicator.swift
//  Clean
//
//  Created by Nguyen, Toan on 2/21/19.
//  Copyright © 2019 James. All rights reserved.
//

import Foundation
import UIKit

public class CustomIndicator {
    let indicator = UIActivityIndicatorView()
    var mainView = UIView()
    
    
    func addIndicator(view : UIViewController, alpha : CGFloat ){
        
        mainView = UIView(frame: CGRect(x: 0, y: 0, width: view.view.frame.width, height: view.view.frame.height))
        mainView.backgroundColor = UIColor.white
        mainView.alpha = alpha
        mainView.isHidden = true
        
        indicator.center = mainView.center
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        indicator.color = UIColor.gray
        
        mainView.addSubview(indicator)
        view.view.addSubview(mainView)
        
    }
    
    func startIndicator(timeout : Double){
        mainView.isHidden = false
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeout , execute: {
            self.indicator.stopAnimating()
        })
    }
    
    func stopIndicator(){
       
        indicator.stopAnimating()
         mainView.isHidden = true
    }

}
