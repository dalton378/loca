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
    
    private var floor, bedroom, bathroom, pool, elevator, garden, roof : ListData?
    var directionString = ""; var floorString = ""; var bedroomString = ""; var bathroomString = ""; var poolString = ""; var elevatorString = ""; var gardenString = ""; var roofString = ""
    var delegate: PostCreationAddInfoProtocol?
    var data: ApartmentPostCreation!
    private var direction = ListData(text: ["Đông","Tây","Nam","Bắc","Đông Nam","Đông Bắc", "Tây Nam","Tây Bắc"], id: [1,2,3,4,5,6,7,8])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    private func prepareUI(){
        confirmButton.layer.cornerRadius = 10
        
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
        setData()
    }
    
    private func setData(){
        if data.floor_number != 0 {
            guard let index = floor?.id.firstIndex(of: data.floor_number) else {return}
            floorLabel.text = floor?.text[index]
            floorString = String(data.floor_number)
        }
        if data.bedroom_number != 0 {
                   guard let index = bedroom?.id.firstIndex(of: data.bedroom_number) else {return}
                   bedroomLabel.text = bedroom?.text[index]
                   bedroomString = String(data.bedroom_number)
               }
        if data.bathroom_number != 0 {
                   guard let index = bathroom?.id.firstIndex(of: data.bathroom_number) else {return}
                   bathroomLabel.text = bathroom?.text[index]
                   bathroomString = String(data.bathroom_number)
               }
        if !data.pool.isEmpty {
            guard let index = pool?.id.firstIndex(of: Int(data.pool) ?? 0) else {return}
            poolLabel.text = pool?.text[index]
            poolString = data.pool
        }
        if !data.garden.isEmpty {
            guard let index = garden?.id.firstIndex(of: Int(data.garden) ?? 0) else {return}
            gardenLabel.text = garden?.text[index]
            gardenString = data.garden
        }
        if !data.rooftop.isEmpty {
            guard let index = roof?.id.firstIndex(of: Int(data.rooftop) ?? 0) else {return}
            rooftopLabel.text = roof?.text[index]
            roofString = data.rooftop
        }
        if !data.direction.isEmpty {
            guard let index = direction.id.firstIndex(of: Int(data.direction) ?? 0) else {return}
            directionLabel.text = direction.text[index]
            directionString = data.direction
        }
    }
    
    
    @IBAction func confirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        delegate?.getInfo(direction: directionString, floor: floorString, bedroom: bedroomString, bathroom: bathroomString, pool: poolString, elevator: elevatorString, garden: gardenString, roof: roofString)
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        ListView.removeListView()
    }
    
    @IBAction func showDirectionList(_ sender: UITapGestureRecognizer) {
        ListView.displayListView(view: directionDropdown, listHeight: 150, text: direction.text, id: direction.id, selectionHandler: {(text,id) in
            self.directionLabel.text = text
            self.directionString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showFloorList(_ sender: UITapGestureRecognizer) {
        guard let data = floor else { return}
        ListView.displayListView(view: floorDropDown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.floorLabel.text = text
            self.floorString = String(id)
            ListView.removeListView()
        })
    }
    @IBAction func showBedroomList(_ sender: UITapGestureRecognizer) {
        guard let data = bedroom else { return}
        ListView.displayListView(view: bedroomDropDown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.bedroomLabel.text = text
            self.bedroomString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showBathroomList(_ sender: UITapGestureRecognizer) {
        guard let data = bathroom else { return}
        ListView.displayListView(view: bathroomDropDown, listHeight: 150, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.bathroomLabel.text = text
            self.bathroomString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showPoolList(_ sender: UITapGestureRecognizer) {
        guard let data = pool else { return}
        ListView.displayListView(view: poolDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.poolLabel.text = text
            self.poolString = String(id)
            ListView.removeListView()
        })
    }
    @IBAction func showGardenList(_ sender: Any) {
        guard let data = garden else { return}
        ListView.displayListView(view: gardenDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.gardenLabel.text = text
            self.gardenString = String(id)
            ListView.removeListView()
        })
    }
    
    @IBAction func showElevatorList(_ sender: UITapGestureRecognizer) {
        guard let data = elevator else { return}
        ListView.displayListView(view: elevatorDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.elevatorLabel.text = text
            self.elevatorString = String(id)
            ListView.removeListView()
        })
    }
    @IBAction func showRoofList(_ sender: Any) {
        guard let data = roof else { return}
        ListView.displayListView(view: rooftopDropDown, listHeight: 100, text: data.text, id: data.id, selectionHandler: {(text,id) in
            self.rooftopLabel.text = text
            self.roofString = String(id)
            ListView.removeListView()
        })
    }
    
    private struct ListData{
        var text: [String]
        var id: [Int]
    }
    
}

protocol PostCreationAddInfoProtocol {
    func getInfo(direction: String, floor: String, bedroom: String, bathroom: String, pool: String, elevator: String, garden: String, roof: String)
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
