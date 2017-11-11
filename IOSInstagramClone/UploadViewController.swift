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

        //Hiding keyboard (When The user touches the screen)
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGR)

        //Clickable - Enabled Select Image
        selectedImageView.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(UploadViewController.choosePhoto))
        selectedImageView.addGestureRecognizer(recognizer)
        
        //Post button disable
        postButton.isEnabled = false
    }

    @IBAction func postClicked(_ sender: Any) {
        
        //Post button disable
        postButton.isEnabled = false
        
        //Compress and Convert selected image for upload data
        if let imageData = UIImageJPEGRepresentation(selectedImageView.image!, 0.5){
        
            //Upload picked image
            let imagesFolder = Storage.storage().reference().child("images")
            imagesFolder.child("\(uuid).jpg").putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                   
                    //Create Alert
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    //Create and Add alert button
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    
                    //Show alert
                    self.present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    //Uploaded image
                    let imageURL = metadata?.downloadURL()?.absoluteString
                    
                    //Create Post object
                    let post = ["image" : imageURL!, "postedby" : Auth.auth().currentUser!.email!, "uuid" : self.uuid, "posttext" : self.descriptionTextView.text] as [String : Any]

                    //Send Post object after success image upload
                    Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("post").childByAutoId().setValue(post)

                    //Reset fields
                    self.selectedImageView.image = UIImage(named : "selectImage.jpg")
                    self.descriptionTextView.text = ""
                    self.tabBarController?.selectedIndex = 0
                    
                    //Send broadcastNotification for new post (it will handle in Home Page)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newUpload"), object: nil)

                    
                }
            })
        }
    }

    @objc func choosePhoto() {
        //Pick image from photoLibrary in Device
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        //Show picked and edited image
        present(picker, animated: true, completion: nil)
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Pick image from photoLibrary in Device
        selectedImageView.image = info[UIImagePickerControllerEditedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        //Post button enable
        self.postButton.isEnabled = true
    }
    
    //Hide Keyboad
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}

