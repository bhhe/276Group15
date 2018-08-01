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
    var postIndex : Int?
    
    @IBOutlet weak var postCells: UITableView!
    
    override func viewDidLoad() {
        postCells.separatorColor = UIColor.green
        let postRef = ref.child("Posts")
        for chd in posts{
            postRef.observe(.value) { (snapshot) in
                if snapshot.hasChild(chd.getId()){
                    let snap = snapshot.childSnapshot(forPath: chd.getId())
                    let snap2 = snap.childSnapshot(forPath: "Title")
                    let snap3 = snap.childSnapshot(forPath: "GardenId")
                    let name = snap2.value as! String
                    let gId = snap3.value as! String
                    chd.setPostName(postName: name)
                    chd.setGardId(gardId: gId)
                    self.postCells.reloadData()
                }
            }
            /*
            //print(chd.getId())
            group.enter();
            postRef.child(chd.getId()).child("Title").observe(.value) { (snapshot) in
                //print(snapshot)
                let val = snapshot.value as! String
                chd.setPostName(postName: val)
                self.group.leave()
            }
            group.enter();
            postRef.child(chd.getId()).child("GardenId").observe(.value) { (snapshot) in
                let val = snapshot.value as! String
                //print(val)
                chd.setGardId(gardId: val)
                self.group.leave()
            }
            */
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
        if indexPath.row < posts.count{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{cell.textLabel?.text = self.posts[indexPath.row].getName()})
        }
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!
            , size : 22)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postId = posts[indexPath.row].getId()
        usrPost = posts[indexPath.row]
        postIndex = indexPath.row
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{self.performSegue(withIdentifier: "acceptSegue", sender: self)})
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "acceptSegue"{
            let receiverVC = segue.destination as! acceptVC
            receiverVC.acptData = acceptDatas
            receiverVC.usrPost = self.usrPost
            receiverVC.postIndex = postIndex;
        }else{
            let receiverVC = segue.destination as! GardenShareController
            receiverVC.tableView.reloadData()
        }
    }

    @IBAction func unwindToYP(segue : UIStoryboardSegue){
        postCells.reloadData()
        viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now(), execute:{self.performSegue(withIdentifier: "unwindBack", sender: self)})
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
