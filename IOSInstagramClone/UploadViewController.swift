//
//  UploadViewController.swift
//  IOSInstagramClone
//
//  Created by Ercan Pinar on 9/11/17.
//  Copyright © 2017 Ercan PINAR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var postButton: UIButton!
    var uuid = NSUUID().uuidString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //hiding keyboard
        
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGR)
        
        selectedImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.choosePhoto))
        selectedImageView.addGestureRecognizer(recognizer)
        
        postButton.isEnabled = false
    }

    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    @IBAction func postClicked(_ sender: Any) {
        
        postButton.isEnabled = false
        
        let imagesFolder = Storage.storage().reference().child("images")
        
        if let imageData = UIImageJPEGRepresentation(selectedImageView.image!, 0.5){
            
            imagesFolder.child("\(uuid).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    let post = ["image" : imageURL!, "postedby" : Auth.auth().currentUser!.email!, "uuid" : self.uuid, "posttext" : self.descriptionTextView.text] as [String : Any]
                    
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)
                    
                    
                    self.selectedImageView.image = UIImage(named : "selectImage.jpg")
                    self.descriptionTextView.text = ""
                    self.tabBarController?.selectedIndex = 0
                    
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUpload"), object: nil)

                    
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
        
        self.postButton.isEnabled = true
    }
    
}

