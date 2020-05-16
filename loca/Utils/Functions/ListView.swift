//
//  ListView.swift
//  loca
//
//  Created by Toan Nguyen on 5/16/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import UIKit

class ListView {
    static var itemView: ListViewCustom?
    static func displayListView(view: UIView, listHeight: Int, text: [String], id: [Int], selectionHandler: @escaping ((String, Int) -> Void) ){
        itemView?.removeFromSuperview()
        var y = view.frame.maxY
        
        if y + CGFloat(listHeight) > (view.superview?.frame.height)! {
            y = view.frame.minY - CGFloat(listHeight + 10)
        }
        itemView = ListViewCustom(frame: CGRect(x: view.frame.minX, y: y + 5, width: view.frame.width, height: CGFloat(listHeight)))
        itemView?.setData(data: text, ids: id, selectionHandler: selectionHandler)
        itemView?.addClearInAnimation()
        view.superview!.addSubview(itemView!)
    }
    
    static func removeListView(){
        itemView?.removeFromSuperview()
    }
}
