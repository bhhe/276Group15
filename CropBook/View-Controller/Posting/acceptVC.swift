//
//  acceptVC.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-18.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

//Accepting applications and adding other users to participate in
// the garden
class acceptVC: UIViewController,UITableViewDataSource,UITableViewDelegate   {

    var acptData : [AcceptData] = []
    var usrPost = UserPost(postId: "false", isOwner: true)
    var ref = Database.database().reference()
    var uid = Auth.auth().currentUser?.uid
    @IBOutlet weak var postTitle: UINavigationItem!
    @IBOutlet weak var cells: UITableView!
    @IBOutlet weak var infoText: UITextView!
    
    var group = DispatchGroup()
    
    override func viewDidLoad() {
        postTitle.title = usrPost.getName()
        let gId = usrPost.getGId()
        
        let reqRef = ref.child("Posts/\(usrPost.getId())/Requests")
        group.enter()
        reqRef.observe(.value, with: {(snapshot) in
            for snap in snapshot.children{
                let userSnap = snap as! DataSnapshot
                let uID = userSnap.key
                let userDict = userSnap.value as! [String:String]
                let info = userDict["info"] as! String
                let name = userDict["name"] as! String
                let applicData = AcceptData(uId: uID, gardenId: gId, name: name, info: info)
                self.acptData.append(applicData)
                self.cells.reloadData()
            }
            self.group.leave()
        })
        
        cells.dataSource = self
        cells.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acptData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppliCell", for : indexPath )
       DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{cell.textLabel?.text = self.acptData[indexPath.row].name})
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let info = acptData[indexPath.row].info
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.infoText.text = info})
        
    }
 
    @IBAction func acceptPressed(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.performSegue(withIdentifier: "unwindAccept", sender: self)})
    }
    
    @IBAction func removePressed(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{for chd in self.acptData{
            print(chd.uId)
            print(chd.name)
            print(chd.info)
            }})
    }
    
    
    @IBAction func deletePost(_ sender: Any) {
        let postRef = ref.child("Posts").child(usrPost.getId())
        let user = uid as! String
        let uPostRef = ref.child("Users/\(user)/Posts").child(usrPost.getId())
        postRef.removeValue{error, _ in print(error)}
        uPostRef.removeValue{error, _ in print(error)}
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.performSegue(withIdentifier: "unwindAccept", sender: self)})
    }
    
}
