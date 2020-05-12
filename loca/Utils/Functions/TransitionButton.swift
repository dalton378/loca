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


class TransitionButtonExtent: TransitionButton {
    func stopAnimation(animationStyle: StopAnimationStyle = .normal, color: UIColor, revertAfterDelay delay: TimeInterval = 1.0, completion: (() -> Void)? = nil) {
        stopAnimation()
        let delayToRevert = max(delay, 0.2)
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundColor = color
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + delayToRevert) {
            completion?()
        }
    }
}
