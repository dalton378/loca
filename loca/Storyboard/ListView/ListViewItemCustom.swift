//
//  ListViewItemCustom.swift
//  loca
//
//  Created by Toan Nguyen on 5/7/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class ListViewItemCustom: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var listViewItem: UILabel!
    var text = ""
    var id = 0
    var selectionHandler: ((String, Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ListViewItem", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func setItem(item: String, id: Int){
        listViewItem.text = item
        text = item
        self.id = id
    }
    
    
    @IBAction func selectItem(_ sender: Any) {
        selectionHandler!(self.text,self.id)
    }
    
}
