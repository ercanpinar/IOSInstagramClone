//
//  UploadViewController.swift
//  IOSInstagramClone
//
//  Created by Ercan Pinar on 9/11/17.
//  Copyright © 2017 Ercan PINAR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        selectedImageView.isUserInteractionEnabled = true
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.choosePhoto))
        selectedImageView.addGestureRecognizer(recognizer)
    }

    @IBAction func postClicked(_ sender: Any) {
        
        let imagesFolder = Storage.storage().reference().child("images")
        
        if let imageData = UIImageJPEGRepresentation(selectedImageView.image!, 0.5){
            
            imagesFolder.child("\(uuid).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let imageURL = metadata?.downloadURL()?.absoluteURL
                    print(imageURL)
                    
                }
            })
        }
    }

    @objc func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        selectedImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
}

