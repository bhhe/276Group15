//
//  GardenShareController.swift
//  CropBook
//
//  Created by jon on 2018-07-01.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
let weather = Weather()
import FirebaseDatabase
import FirebaseAuth

class GardenShareController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : DatabaseReference?
    var postings = [PostData]()
    var gardens : [GardenData] = []
    let uid = Auth.auth().currentUser?.uid
    var myIndex = 0
    var postInfo : Posting = Posting()
    var gardenName = ""
    var gardId = ""
    var myCrops : [String] = []
    var myPosts : [UserPost] = []
    override func viewDidLoad() {
        ref = Database.database().reference()
        let userRef = ref?.child("Posts")
        
        userRef?.observe(.childAdded, with: { (gardenSnapshot) in
            let postId = gardenSnapshot.key as? String
            let postSnap = gardenSnapshot.childSnapshot(forPath: "Title")
            let postTitle = postSnap.value as? String
            let postData = PostData(postId: postId!, postTitle: postTitle!,gardenId : "") as? PostData
            self.postings.append(postData!)
            self.tableView.reloadData()
        })
        
        let uRef = ref?.child("Users").child(uid!).child("Posts")
        
        uRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                let val = snap.value as! Bool
                let usrPost = UserPost(postId: key, isOwner: val)
                self.myPosts.append(usrPost)
            }
        })
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //returns number of rows in data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postings.count
    }
    
    //return cell for display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell")
        
        cell?.textLabel?.text = postings[indexPath.row].getTitle()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        createPosting()
        addCrops()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{ self.performSegue(withIdentifier: "postSegue", sender: self)})
    }
    
    
    @IBAction func composePost(_ sender: Any) {
        gardens.removeAll()
        let gardensRef = ref?.child("Users").child(uid!).child("Gardens")
        gardensRef?.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                let val = snap.value as! Bool
                if val == true{
                    let gardenData = GardenData(gardenId: key, gardenName: self.gardenName )
                    self.gardens.append(gardenData)
                }
            }
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
            self.performSegue(withIdentifier: "createPost", sender: self)})
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "postSegue"{
            let receiverVC = segue.destination as! PostVC
            receiverVC.post = postInfo
        }else if segue.identifier == "createPost"{
            let receiverVC = segue.destination as! ComposeVC
            receiverVC.gardensIds = self.gardens
        }else{
            let receiverVC = segue.destination as! YourPostsVC
            receiverVC.posts = self.myPosts
        }
    }
    
    func createPosting(){
        let postRef = ref?.child("Posts/\(postings[myIndex].getGardenId())")
        self.postInfo.setPostRef(postRef: postRef!)
        postRef?.child("Title").observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as! String
            self.postInfo.setTitle(title: val)
        })
        postRef?.child("GardenId").observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as! String
            self.postInfo.setGardenRef(gardenRef: val)
        })
        postRef?.child("Description").observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as! String
            self.postInfo.setDescription(description: val)
        })
        postRef?.child("Harvest").observeSingleEvent(of: .value, with: { (snapshot) in
            let val = snapshot.value as! String
            self.postInfo.setHarvest(harvest: val)
        })
        
        let crops = ["Blueberries","Apples","Asparagus"]
        self.postInfo.setCrops(cropNames: crops)
    }
    
    func addCrops(){
        let gardenId = postings[myIndex].getGdnId()
        let GardenRef = ref?.child("Gardens/\(gardenId)/CropList")
        GardenRef?.observe(.value, with: {(snapshot) in
            for child in snapshot.children.allObjects as![DataSnapshot]{
                let cropObject=child.value as? [String:AnyObject]
                let cropname=cropObject?["CropName"]
                self.myCrops.append(cropname as! String)
            }
        })
    }
    
    @IBAction func yourPostsPressed(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
            self.performSegue(withIdentifier: "ypSegue", sender: self)})
    }
    
    @IBAction func unwindToShare(segue : UIStoryboardSegue){
        
        
    }
}
