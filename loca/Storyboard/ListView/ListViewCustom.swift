//
//  ListViewCustom.swift
//  loca
//
//  Created by Toan Nguyen on 5/7/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class ListViewCustom: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var listViewItem: ListViewItemCustom!
    var viewHeight = 0
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ListViewCustom", owner: self, options: nil)
        contentView.fixInView(self)
        contentView.layer.cornerRadius = 5
    }
    func setData(data: [String], ids: [Int], selectionHandler: @escaping ((String, Int) -> Void)){
        if data.count > 0 {
            for i in 0...data.count - 1 {
                let item = ListViewItemCustom.init(frame: CGRect(x: 0, y: (40 * CGFloat(i)) , width: stackView.frame.width, height: 40))
                item.setItem(item: data[i], id: ids[i])
                item.selectionHandler = selectionHandler
                stackView.addSubview(item)
            }
            viewHeight = (data.count * 40)
            
            for a in stackView.constraints {
                if a.identifier == "innerViewHeigh" {
                    a.constant = CGFloat(viewHeight)
                }
            }
        }
    }
}
