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

    override func viewWillAppear(_ animated: Bool) {
        //When The app has a new post, it will update automatically
        NotificationCenter.default.addObserver(self, selector: #selector(FeedViewController.getDataFromServer), name: NSNotification.Name(rawValue: "newUpload"), object: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Create cell use Customize TabeViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        //Set data to each cell
        cell.postedByLabel.text = userEmailArray[indexPath.row]
        cell.postCommentTextView.text = postCommentArray[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.postImageURLArray[indexPath.row]), completed: nil)
        
        return cell
        
    }
    
    @objc func getDataFromServer() {
        //The posts data get from Server
        Database.database().reference().child("users").observe(DataEventType.childAdded, with: { (snapshot) in
            //Read data in FirebaseResponse
            let values = snapshot.value! as! NSDictionary
            let posts = values["post"] as! NSDictionary
            let postIDs = posts.allKeys
            //Clean data lists
            self.userEmailArray.removeAll()
            self.postImageURLArray.removeAll()
            self.postCommentArray.removeAll()
        
            for id in postIDs {
                //Each post data
                let singlePost = posts[id] as! NSDictionary
                //Add data lists
                self.userEmailArray.append(singlePost["postedby"]! as! String)
                self.postCommentArray.append(singlePost["posttext"]! as! String)
                self.postImageURLArray.append(singlePost["image"]! as! String)
                
            }
            //Refresh tableView with new data
            self.feedTableView.reloadData()
            
        })
        
    }
    
    
    @IBAction func logoutClicked(_ sender: Any) {
        //User removes in phone storage
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.synchronize()
        //The Start Storyboard changed (to LoginViewController)
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVCID") as! LoginViewController
        let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = loginVC
        delegate.rememberLogin()
        
    }
    

}

