//
//  UIViewExtension.swift
//  loca
//
//  Created by Toan Nguyen on 5/1/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    enum ReloadAnimationType {
        case up
        case down
        case left
        case right
        case none
        case clearIn
    }
    
    func addAnimation(animationDirection: ReloadAnimationType, delay: Int) {
        //reloadData()
        
        // let cells = self.visibleCells
        var index = delay
        let tableHeight: CGFloat = self.bounds.size.height
        
        //let cell: UITableViewCell = i as UITableViewCell
        switch animationDirection {
        case .up:
            self.transform = CGAffineTransform(translationX: 0, y: -tableHeight)
            break
        case .down:
            self.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            break
        case .left:
            self.transform = CGAffineTransform(translationX: self.frame.width, y: 0)
            break
        case .right:
            self.transform = CGAffineTransform(translationX: -self.frame.width, y: 0)
            break
        default:
            self.transform = CGAffineTransform(translationX: tableHeight, y: 0)
            break
        }
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.03 * Double(index),
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseIn,
                       animations: { self.transform = CGAffineTransform(translationX: 0, y: 0) },
                       completion: nil)
        index += 1
        layoutIfNeeded()
    }
    
    func addClearInAnimation(){
        self.alpha = 0

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1.0
        })
     layoutIfNeeded()
    }
}

