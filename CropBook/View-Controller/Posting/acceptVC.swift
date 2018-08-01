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
class acceptVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    var acptData : [AcceptData] = []
    var usrPost = UserPost(postId: "false", isOwner: true)
    var ref = Database.database().reference()
    var uid = Auth.auth().currentUser?.uid
    var activeField : UITextField?
    var appInfo : AcceptData?
    var postIndex : Int?
    
    @IBOutlet weak var postTitle: UINavigationItem!
    @IBOutlet weak var cells: UITableView!
    @IBOutlet weak var infoText: UITextView!
    
    var group = DispatchGroup()
    
    override func viewDidLoad() {
        cells.separatorColor = UIColor.green
        cells.reloadData()
        postTitle.title = "Applicants"
        let gId = usrPost.getGId()
        
        //Retrieve all user applications for
        //acceptance or declining
        let reqRef = ref.child("Posts/\(usrPost.getId())/Requests")
        reqRef.observe(.value, with: {(snapshot) in
            for snap in snapshot.children{
                let userSnap = snap as! DataSnapshot
                let uID = userSnap.key
                let userDict = userSnap.value as! [String:AnyObject]
                let email = userDict["email"] as? String ?? ""
                let info = userDict["info"] as? String ?? ""
                let name = userDict["name"] as? String ?? ""
                let applicData = AcceptData(uId: uID, gardenId: gId, name: name, info: info)
                applicData.email = email
                self.acptData.append(applicData)
                self.cells.reloadData()
            }
        })
        
        cells.dataSource = self
        cells.delegate = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return acptData.count
    }
    
    //Applicant information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppliCell", for : indexPath )
        if indexPath.row <= acptData.count{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{cell.textLabel?.text = self.acptData[indexPath.row].name})
        }
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!
            , size : 22)
        
        return cell
    }
    
    //Select applicant to display in next VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        appInfo = acptData[indexPath.row]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.performSegue(withIdentifier: "appliSegue", sender: self)})
    }
    
    //cell size
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    //segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appliSegue"{
            let receiverVC = segue.destination as! ApplicantViewController
            receiverVC.appInfo = self.appInfo!
            receiverVC.postId = usrPost.getId()
        }else{
            let receiverVC = segue.destination as! YourPostsVC
            receiverVC.posts.remove(at: postIndex!)
        }
    }
    
    //Deletes current post from firebase and
    //from user
    @IBAction func deletePost(_ sender: Any) {
        
        let postRef = ref.child("Posts").child(usrPost.getId())
        let user = uid as! String
        let uPostRef = ref.child("Users/\(user)/Posts").child(usrPost.getId())
        postRef.removeValue{error, _ in print(error)}
        uPostRef.removeValue{error, _ in print(error)}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{self.performSegue(withIdentifier: "unwindAccept", sender: self)})
    }
    
    @IBAction func unwindToApps(segue : UIStoryboardSegue){
        acptData.removeAll()
        viewDidLoad()
    }
    
    //Get UICOLOR based on inputted hex parameter
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
