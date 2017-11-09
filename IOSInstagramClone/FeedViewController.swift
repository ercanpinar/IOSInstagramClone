//
//  FeedViewController.swift
//  IOSInstagramClone
//
//  Created by Ercan Pinar on 9/11/17.
//  Copyright © 2017 Ercan PINAR. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var feedTableView: UITableView!
    
    var userEmailArray = [String]()
    var postCommentArray = [String]()
    var postImageURLArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.delegate = self
        feedTableView.dataSource = self
        
        getDataFromServer()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
   
        cell.postedByLabel.text = userEmailArray[indexPath.row]
        cell.postCommentTextView.text = postCommentArray[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.postImageURLArray[indexPath.row]), completed: nil)
        
        return cell
        
    }
    
    func getDataFromServer() {
        
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            
            let values = snapshot.value! as! NSDictionary
            let posts = values["post"] as! NSDictionary

            let postIDs = posts.allKeys
            
            for id in postIDs {
                
                let singlePost = posts[id] as! NSDictionary
                
                self.userEmailArray.append(singlePost["postedby"]! as! String)
                self.postCommentArray.append(singlePost["posttext"]! as! String)
                self.postImageURLArray.append(singlePost["image"]! as! String)
                
            }
            
            self.feedTableView.reloadData()
            
        })
        
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVCID") as! LoginViewController
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginVC
        delegate.rememberLogin()
        
    }
    

}

