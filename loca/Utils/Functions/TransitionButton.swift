//
//  TransitionButton.swift
//  loca
//
//  Created by Toan Nguyen on 5/8/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import TransitionButton

class TransitionButtonCustom {
 
    static func configureTransitionButton(button: TransitionButton, tittle: String, tapHandler: UITapGestureRecognizer?){
        button.backgroundColor = UIColor(named: "UCyan")
        button.setTitle(tittle, for: .normal)
        button.cornerRadius = 10
        button.spinnerColor = .white
        guard let gesture = tapHandler else {return}
        button.addGestureRecognizer(gesture)
    }
}
