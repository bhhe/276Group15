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
    
    @IBOutlet weak var applyBtn: UIButton!
    
    
    var ref : DatabaseReference?
    var gardensIds : [GardenData]?
    var gardenStrings : [String] = []
    var gardenId = ""
    let uid = Auth.auth().currentUser?.uid
    let group = DispatchGroup()
    var cityName = ""
    override func viewDidLoad() {
        applyBtn.layer.cornerRadius = 5
        ref = Database.database().reference()
        guard let gardenRef = ref?.child("Gardens") else{ return }
        
        for chd in gardensIds!{
            gardenRef.child(chd.getId()).child("gardenName").observeSingleEvent(of: .value) { (snapshot) in
                let val = snapshot.value
                chd.setName(gardenName: val as! String)
            }
            gardenRef.child(chd.getId()).child("Address").observeSingleEvent(of: .value) { (snapshot) in
                let val = snapshot.value as! String
                let str = val.split(separator: ",")
                let city: String = String(str[1]).trimmingCharacters(in: .whitespacesAndNewlines)
                chd.city = city
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
            cell.textLabel?.text = self.gardensIds![indexPath.row].getName()
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectGardenBtn.setTitle(cell?.textLabel?.text, for: .normal)
        gardenId = gardensIds![indexPath.row].getId()
        cityName = gardensIds![indexPath.row].city
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
            postRef?.child("Address").setValue(cityName)
            let userRef = ref?.child("Users").child(uid!).child("Posts").child(postKey)
            userRef?.setValue(true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute:{self.performSegue(withIdentifier: "unwindCompose", sender: self)})
    }

}
