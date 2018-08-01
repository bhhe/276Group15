//
//  PostVC.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-15.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PostVC: UIViewController,UITableViewDataSource,UITableViewDelegate  {
    
    var ref = Database.database().reference()
    var post : Posting = Posting()
    var crops = [String]()
    let uid = Auth.auth().currentUser?.uid
    var vApply = true
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var harvestField: UILabel!
    @IBOutlet weak var cropsView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    @IBOutlet weak var errorText: UILabel!
    
    override func viewDidLoad() {
        applyBtn.layer.cornerRadius = 5
        let cropRef = ref.child("Gardens/\(post.gardenRef)/CropList")
        let userRef = ref.child("Users/\(uid!)/Gardens")
        
        //Checks to see if user has garden in post
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let gardenId = snap.key
                if gardenId == self.post.gardenRef{
                    self.vApply = false
                }
                
            }
        }
        
        //Retrieve all crops from a garden in firebase
        cropRef.observe(.value) { (snapshot) in
            for snap in snapshot.children{
                let cropSnap = snap as! DataSnapshot
                let cropDict = cropSnap.value as! [String:AnyObject]
                let info = cropDict["CropName"] as? String
                self.crops.append(info!)
            }
            self.cropsView.reloadData()
        }
        
        //Checks to see if Apply button is disabled
        //Users can't apply to gardens they are part of
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
            if(self.vApply == false){
                self.applyBtn.alpha = 0.5
                self.applyBtn.isEnabled = false
                self.errorText.isHidden = false
            }else{
                self.applyBtn.alpha = 1
                self.applyBtn.isEnabled = true
                self.errorText.isHidden = true
            }
        })
        
        //Set Text fields and ensure
        //cropviews working properly
        cropsView.delegate = self
        cropsView.dataSource = self
        descriptionField.text = post.getDescription()
        descriptionField.isEditable = false
        postTitle.text = post.getTitle()
        harvestField.text = post.getHarvest()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crops.count
    }
    
    //Display all crops from Garden in the Post
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cropCell", for : indexPath )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{
            cell.textLabel?.text = self.crops[indexPath.row]})
        return cell
    }
    
    //Determines if user can apply for post
    //No if they are already part of garden
    func isValidApply(){
        let uRef = ref.child("Users/\(uid)")
        let gRef = uRef.child("Gardens")
        let pRef = uRef.child("Posts")
        gRef.observeSingleEvent(of: .value) { (snapshot) in
            print(self.post.getGardRef())
            if snapshot.hasChild(self.post.getGardRef()){
                self.vApply = false
                print("It happened")
            }
        }
        
        pRef.observeSingleEvent(of: .value) { (snapshot) in
            print(self.post.getRef().key)
            if snapshot.hasChild(self.post.getRef().key){
                self.vApply = false
                print("It happened")
            }
        }
    }
    
    //Proceed to fill out information for Application
    @IBAction func applyPressed(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{self.performSegue(withIdentifier: "applySegue", sender: self)})
    }
    
    //Segue prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! ApplyVC
        receiverVC.validApply = self.vApply
        receiverVC.postRef = post.getRef()
    }
    
}
