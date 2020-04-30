//
//  Messages.swift
//  loca
//
//  Created by Dalton on 4/14/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import Foundation
import SwiftMessages

public class Messages {
    static func displayErrorMessage(message: String) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: "Warning", body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10
        view.button?.isHidden = true

        // Show the message.
        SwiftMessages.show(view: view)
    }
    
    static func displaySuccessMessage(message: String) {
        let view = MessageView.viewFromNib(layout: .centeredView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: "Success", body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        // Show the message.
        SwiftMessages.show(view: view)
    }
    
    static func displayCustomMessage(){
        let view = SignInMessage(frame: CGRect(x: 0, y: 100, width: 300, height: 200))
        view.doneAction = {SwiftMessages.hide()}
        view.configureDropShadow()
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.presentationStyle = .center
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
        
    }
}
