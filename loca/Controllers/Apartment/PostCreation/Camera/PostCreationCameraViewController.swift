//
//  PostCreationCameraViewController.swift
//  loca
//
//  Created by Toan Nguyen on 5/6/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
import Alamofire
import Foundation

class PostCreationCameraViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var photoCollection = [UIImage]()
    var delegate: PostCreationCameraProtocol?
    var store = AlamofireStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.dataSource = self
        collection.delegate = self
        confirmButton.layer.cornerRadius = 10
    }
    
    
    @IBAction func cameraTap(_ sender: UITapGestureRecognizer) {
        showAlert()
    }
    @IBAction func confirm(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        //delegate?.getPhotos(phots: self.photoCollection)
        

        
        
        store.postFile(file: photoCollection.first!, completionHandler: {(result,data) in
            switch result {
            case .success(let dataString):
                let parsedData = dataString.data(using: .utf8)
                guard let newData = parsedData, let autParams = try? JSONDecoder().decode(ApartmentPhotoReturn.self, from: newData) else {return}
            case .failure(let data):
                print(data)
                Messages.displayErrorMessage(message: "Upload file không thành công!")
            }
        })
    }
    
   
    


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: "photo_collection_cell", for: indexPath) as! PostCreationCameraCollectionViewCell
        cell.setPhoto(photo: photoCollection[indexPath.row])
        return cell
    }
    
}

extension PostCreationCameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //This is the tap gesture added on my UIImageView.
    @IBAction func didTapOnImageView(sender: UITapGestureRecognizer) {
        //call Alert function
        self.showAlert()
    }

    //Show alert to selected the media source type.
    private func showAlert() {

        let alert = UIAlertController(title: "Image Selection", message: "From where you want to pick this image?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    //get image from source type
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {

        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {

            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }

    //MARK:- UIImagePickerViewDelegate.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            
            self?.photoCollection.append(image)
            self?.collection.reloadData()
            
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PostCreationCameraViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}

protocol PostCreationCameraProtocol {
    func getPhotos(phots: [UIImage])
}
