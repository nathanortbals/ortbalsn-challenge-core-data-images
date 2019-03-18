//
//  DocumentViewController.swift
//  ortbalsn-challenge-core-data
//
//  Created by Nathan Ortbals on 2/18/19.
//  Copyright © 2019 Nathan Ortbals. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    var existingImage: Image?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let saveBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveImage))
        self.navigationItem.rightBarButtonItem  = saveBarButtonItem
        
        titleTextField.text = existingImage?.title
        imageView.image = existingImage?.image
    }
    
    @IBAction func openCamera(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not supported by this device")
            return
        }
        
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    
    @IBAction func openPhotoLibrary(_ sender: Any) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            print("can't open photo library")
            return
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    
    @objc
    func saveImage() {
        let title = titleTextField.text
        let image = imageView.image
        print(image?.size)
        
        if let existingImage = existingImage {
            existingImage.title = title
            existingImage.image = image
            print(existingImage.rawImage?.length)
            existingImage.dateModified = Date()
        }
        else {
            existingImage = Image(title: title, image: image)
        }
        
        if let imageEntity = existingImage {
            do {
                let managedContext = imageEntity.managedObjectContext
                try managedContext?.save()
                
                self.navigationController?.popViewController(animated: true)
            } catch{
                print("Image not saved")
            }
        }
    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        imageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
        
        print("did cancel")
    }
}
