//
//  YourPostsVC.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-18.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class YourPostsVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    let ref = Database.database().reference()
    var posts : [UserPost] = []
    var gardIds : [String] = []
    var postId : String = ""
    var gardId : String = ""
    var acceptDatas : [AcceptData] = []
    var acptData = AcceptData()
    override func viewDidLoad() {
        let userRef = ref.child("Posts")
        print(posts.count)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for : indexPath )
        cell.textLabel?.text = posts[indexPath.row].getId()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        postId = posts[indexPath.row].getId()
        getRequests()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{self.performSegue(withIdentifier: "acceptSegue", sender: self)})
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! acceptVC
        
    }
    
    func getRequests(){
        let postRef = ref.child("Posts").child(postId).child("Requests")

        postRef.observe(.value, with: {(snapshot) in
            for snap in snapshot.children{
                let userSnap = snap as! DataSnapshot
                let uID = userSnap.key
                let userDict = userSnap.value as! [String:AnyObject]

                self.acptData = AcceptData()
                let info = userDict["info"] as! String
                let name = userDict["name"] as! String
                print(info)
                print(name)
                print(uID)
                self.acptData.setInfo(info: info)
                self.acptData.setName(name: name)
                self.acptData.setPostId(pId: uID)
            }
        })
    }
}
