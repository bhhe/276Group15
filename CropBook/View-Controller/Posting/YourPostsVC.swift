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
    var usrPost = UserPost(postId: "None", isOwner: true)
    var postId : String = ""
    var gardId : String = ""
    var acceptDatas : [AcceptData] = []
    var acptData = AcceptData()
    var group = DispatchGroup()
    
    override func viewDidLoad() {
        let postRef = ref.child("Posts")
        for chd in posts{
            print(chd.getId())
            group.enter();
            postRef.child(chd.getId()).child("Title").observe(.value) { (snapshot) in
                print(snapshot)
                let val = snapshot.value as! String
                chd.setPostName(postName: val)
                self.group.leave()
            }
            
            group.enter();
            postRef.child(chd.getId()).child("GardenId").observe(.value) { (snapshot) in
                let val = snapshot.value as! String
                print(snapshot)
                chd.setGardId(gardId: val)
                self.group.leave()
            }
        }

        super.viewDidLoad()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for : indexPath )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{cell.textLabel?.text = self.posts[indexPath.row].getName()})
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postId = posts[indexPath.row].getId()
        usrPost = posts[indexPath.row]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{self.performSegue(withIdentifier: "acceptSegue", sender: self)})
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! acceptVC
        receiverVC.acptData = acceptDatas
        receiverVC.usrPost = self.usrPost
    }
    
    @IBAction func unwindToYP(segue : UIStoryboardSegue){
        viewDidLoad()
    }
}
