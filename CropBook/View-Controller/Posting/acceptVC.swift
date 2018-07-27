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
class acceptVC: UIViewController {

    var acptData : [AcceptData] = []
    var usrPost = UserPost(postId: "false", isOwner: true)
    var ref = Database.database().reference()
    var uid = Auth.auth().currentUser?.uid
    @IBOutlet weak var postTitle: UINavigationItem!
    
    var group = DispatchGroup()
    
    override func viewDidLoad() {
        postTitle.title = usrPost.getName()
        print(usrPost.getName())
        print(usrPost.getGId())
        let reqRef = ref.child("Posts/\(usrPost.getId())/Requests")
        reqRef.observe(.value, with: {(snapshot) in
            //self.group.enter()
            /*
            for snap in snapshot.children{
                let userSnap = snap as! DataSnapshot
                let uID = userSnap.key
                let userDict = userSnap.value as! [String:String]
                let info = userDict["info"] as! String
                let name = userDict["name"] as! String
                print(info)
                print(name)
                print(uID)
                self.group.leave()
            }
             */
        })
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.performSegue(withIdentifier: "unwindAccept", sender: self)})
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
