//
//  ComposeVC.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-13.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ComposeVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var createPost: UIButton!
    
    @IBOutlet weak var selectGardenBtn: UIButton!
    
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var harvestField: UITextView!
    
    var ref : DatabaseReference?
    var gardensIds : [GardenData]?
    var gardenStrings : [String] = []
    var gardenId = ""
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        //createPost?.isUserInteractionEnabled = false
        //createPost?.alpha = 0.5
        ref = Database.database().reference()
        guard let gardenRef = ref?.child("users").child(uid!) else{ return }
        
        gardenRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                print("key = \(key) , value = \(value!)")
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated : Bool){
        /*
        for gData in gardensIds!{
            let gardenId = gData.getId()
            let nameRef = ref?.child("Gardens").child(gardenId).child("gardenName")
            nameRef?.observeSingleEvent(of: .value, with: { (snapshot) in
                let name = snapshot.value as! String
                gData.setName(gardenName: name)
            })
        }
        */
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (gardensIds?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gardenCell", for : indexPath )
        cell.textLabel?.text = gardensIds![indexPath.row].getId()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectGardenBtn.setTitle(cell?.textLabel?.text, for: .normal)
        gardenId = gardensIds![indexPath.row].getId()
        
    }
    
    @IBAction func selectGarden(_ sender: Any) {
       print(selectGardenBtn.titleLabel?.text)
    }
    
    @IBAction func addPost(_ sender: Any) {
        let check1 = textView.text
        let check2 = gardenId
        let check3 = descriptionField.text
        let check4 = harvestField.text
        
        if((check1?.isEmpty)! || (check3?.isEmpty)! ||
            (check4?.isEmpty)! || check2 == ""){
        }else{
            let postKey = ref?.child("Posts").childByAutoId().key as! String
            let postRef = ref?.child("Posts").child(postKey)
            postRef?.child("Title").setValue(check1)
            postRef?.child("GardenId").setValue(check2)
            postRef?.child("Description").setValue(check3)
            postRef?.child("Poster").setValue(uid)
            postRef?.child("Harvest").setValue(check4)
            let userRef = ref?.child("Users").child(uid!).child("Posts").child(postKey)
            userRef?.setValue(true)
        }
        
        /*ref?.child("Posts").childByAutoId().child("test").setValue(textView.text)
        presentingViewController?.dismiss(animated: true, completion: nil)
         */
        performSegue(withIdentifier: "unwindCompose", sender: self)
    }
    
    @IBAction func removePost(_ sender: Any) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }

}
