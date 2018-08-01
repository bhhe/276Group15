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
    var group = DispatchGroup()
    
    override func viewDidLoad() {
        postings = [PostData]()
        myPosts = [UserPost]()
        
        ref = Database.database().reference()
        let userRef = ref?.child("Posts")
        userRef?.observeSingleEvent(of: .value, with: { (gardenSnapshot) in
            for child in gardenSnapshot.children{
                let snap = child as! DataSnapshot
                let snap2 = snap.childSnapshot(forPath: "Title")
                let snap3 = snap.childSnapshot(forPath: "Address")
                let pId = snap.key
                let pTitle = snap2.value as! String
                let postData = PostData(postId: pId, postTitle: pTitle,gardenId : "")
                postData.city = snap3.value as? String
                self.postings.append(postData)
            }
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = Auth.auth().currentUser{
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //num of rows in tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(postings.count)
        return postings.count
    }
    
    //return cell for display
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "PostCell")
        
        //change cell text
        if(indexPath.row <= postings.count){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
            cell.textLabel?.text = self.postings[indexPath.row].getTitle()
            cell.detailTextLabel?.text = self.postings[indexPath.row].city
        })
        }
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!
                                      , size : 22)
        cell.detailTextLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!
                                            , size : 15)
        
        //alternate color depending on row
        if indexPath.row % 2 == 0{
            cell.backgroundColor = UIColorFromRGB(rgbValue: 0xF6FED9)
        }else{
            cell.backgroundColor = UIColorFromRGB(rgbValue: 0xCAE1C8)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        createPosting()
        addCrops()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{ self.performSegue(withIdentifier: "postSegue", sender: self)})
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
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
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
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
        viewDidLoad()
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


