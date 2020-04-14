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
        let view = MessageView.viewFromNib(layout: .statusLine)
        view.configureTheme(.error)
        view.configureDropShadow()
        view.configureContent(title: "Warning", body: message)
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        // Reduce the corner radius (applicable to layouts featuring rounded corners).
        (view.backgroundView as? CornerRoundingView)?.cornerRadius = 10

        // Show the message.
        SwiftMessages.show(view: view)
    }
}
