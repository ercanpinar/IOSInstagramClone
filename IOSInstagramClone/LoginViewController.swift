//
//  LoginViewController.swift
//  IOSInstagramClone
//
//  Created by Ercan Pinar on 9/11/17.
//  Copyright © 2017 Ercan PINAR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func signInClicked(_ sender: Any) {
        
        //Control Fields
        if emailTextField.text != "" && passwordTextField.text != "" {
            //Sign In control in Server (Firebase)
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if error != nil {
                    
                    //Create Alert
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    
                    //Create and Add alert button
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    
                    //Show alert
                    self.present(alert, animated: true, completion: nil)
                
                } else {
            
                    //Save user data in Local Storage
                    UserDefaults.standard.set(user!.email, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    //Invoke RememberLoginFunction for storyboard settings
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
            
                }
                
            })
        } else {
            
            //Create Alert
            let alert = UIAlertController(title: "Error", message: "Please check email and password", preferredStyle: UIAlertControllerStyle.alert)
           
            //Create and Add alert button
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            
            //Show alert
            self.present(alert, animated: true, completion: nil)
        
        }
    }

    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user, error) in
                if error != nil {
                    
                    //Create Alert
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                   
                    //Create and Add alert button
                    let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
                    alert.addAction(okButton)
                    
                     //Show alert
                    self.present(alert, animated: true, completion: nil)
                
                } else {
                    
                    //Save user data in Local Storage
                    UserDefaults.standard.set(user!.email, forKey: "user")
                    UserDefaults.standard.synchronize()
                    
                    //Invoke RememberLoginFunction for storyboard settings
                    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.rememberLogin()
                    
                }
                
            })
        } else {
            
            //Create Alert
            let alert = UIAlertController(title: "Error", message: "Please check email and password", preferredStyle: UIAlertControllerStyle.alert)
            
            //Create and Add alert button
            let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(okButton)
            
            //Show alert
            self.present(alert, animated: true, completion: nil)
        
        }
        
    }
    
    
}
