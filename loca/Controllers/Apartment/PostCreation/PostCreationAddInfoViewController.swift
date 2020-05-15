//
//  PostCreationAddInfoViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/6/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit

class PostCreationAddInfoViewController: UIViewController {
    
    
    @IBOutlet weak var directionDropdown: UIView!
    @IBOutlet weak var bedroomDropDown: UIView!
    @IBOutlet weak var floorDropDown: UIView!
    @IBOutlet weak var bathroomDropDown: UIView!
    @IBOutlet weak var poolDropDown: UIView!
    @IBOutlet weak var elevatorDropDown: UIView!
    @IBOutlet weak var gardenDropDown: UIView!
    @IBOutlet weak var rooftopDropDown: UIView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var bedroomLabel: UILabel!
    @IBOutlet weak var bathroomLabel: UILabel!
    @IBOutlet weak var poolLabel: UILabel!
    @IBOutlet weak var elevatorLabel: UILabel!
    @IBOutlet weak var gardenLabel: UILabel!
    @IBOutlet weak var rooftopLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    private var direction, floor, bedroom, bathroom, pool, elevator, garden, roof : ListData?
    var itemView: ListViewCustom?
    
    var delegate: PostCreationAddInfoProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        // Do any additional setup after loading the view.
    }
    
    private func prepareUI(){
        direction = ListData.init(text: ["Đông","Tây","Nam","Bắc","Đông Nam","Đông Bắc", "Tây Nam","Tây Bắc"], id: [1,2,3,4,5,6,7,8])
        
        var num = [Int]()
        var data = [String]()
        for i in 1...50 {
            num.append(i)
            data.append(String(i) )
        }
        floor = ListData.init(text: data, id: num)
        bedroom = ListData.init(text: data, id: num)
        bathroom = ListData.init(text: data, id: num)
        pool = ListData.init(text: ["Có","Không"], id: [1,2])
        garden = ListData.init(text: ["Có","Không"], id: [1,2])
        roof = ListData.init(text: ["Có","Không"], id: [1,2])
        elevator = ListData.init(text: ["Có","Không"], id: [1,2])
        registerForKeyboardNotifications()
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.getInfo()
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        itemView?.removeFromSuperview()
    }
    
    @IBAction func showDirectionList(_ sender: UITapGestureRecognizer) {
        guard let data = direction else { return}
        displayListView(view: directionDropdown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.directionLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showFloorList(_ sender: UITapGestureRecognizer) {
        guard let data = floor else { return}
        displayListView(view: floorDropDown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.floorLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    @IBAction func showBedroomList(_ sender: UITapGestureRecognizer) {
        guard let data = bedroom else { return}
        displayListView(view: bedroomDropDown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.bedroomLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showBathroomList(_ sender: UITapGestureRecognizer) {
        guard let data = bathroom else { return}
        displayListView(view: bathroomDropDown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.bathroomLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showPoolList(_ sender: UITapGestureRecognizer) {
        guard let data = pool else { return}
        displayListView(view: poolDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.poolLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    @IBAction func showGardenList(_ sender: Any) {
        guard let data = garden else { return}
        displayListView(view: gardenDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.gardenLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    @IBAction func showElevatorList(_ sender: UITapGestureRecognizer) {
        guard let data = elevator else { return}
        displayListView(view: elevatorDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.elevatorLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    @IBAction func showRoofList(_ sender: Any) {
        guard let data = roof else { return}
        displayListView(view: rooftopDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.rooftopLabel.text = text
            self.itemView?.removeFromSuperview()
        })
    }
    
    
    private func displayListView(view: UIView, listHeight: Int, text: [String], id: [Int], selectionHandler: @escaping ((String, Int) -> Void) ){
        itemView?.removeFromSuperview()
        
        var y = view.frame.maxY
        
        if y + CGFloat(listHeight) > (view.superview?.frame.height)! {
            y = view.frame.minY - CGFloat(listHeight + 10)
        }
        itemView = ListViewCustom(frame: CGRect(x: view.frame.minX, y: y + 5, width: view.frame.width, height: CGFloat(listHeight)))
        itemView!.setData(data: text, ids: id, selectionHandler: selectionHandler)
        itemView?.addClearInAnimation()
        self.view.addSubview(itemView!)
        
    }
    
    private struct ListData{
        var text: [String]
        var id: [Int]
    }
    
}

protocol PostCreationAddInfoProtocol {
    func getInfo()
}

extension PostCreationAddInfoViewController {
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
