//
//  ContactViewController.swift
//  loca
//
//  Created by Dalton on 5/11/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import TransitionButton

class ContactViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var topicTextField: SkyFloatingLabelTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var confirmButton: TransitionButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func prepareUI() {
        setEmptyBackButton()
        FloatingTextField.configureFloatingText(textfield: nameTextField, placeHolder: "Tên", title: "Tên")
        FloatingTextField.configureFloatingText(textfield: phoneTextField, placeHolder: "Số điện thoại", title: "Số điện thoại")
        FloatingTextField.configureFloatingText(textfield: emailTextField, placeHolder: "Email", title: "Email")
        FloatingTextField.configureFloatingText(textfield: topicTextField , placeHolder: "Chủ đề", title: "Chủ đề")
        
        contentTextView.layer.cornerRadius = 10
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.darkGray.cgColor
        confirmButton.layer.cornerRadius = 10
        registerForKeyboardNotifications()
    }
    
}

extension ContactViewController {
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func adjustForKeyboard(_ notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
}
