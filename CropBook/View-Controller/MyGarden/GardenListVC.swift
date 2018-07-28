//
//  GardenInterface.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-01.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

var GardenList=[MyGarden?]()
var OnlineGardenList=[MyGarden?]()
var OfflineGardenList=[MyGarden?]()

class GardenInterface: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    let ref=Database.database().reference()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Online{
            return OnlineGardenList.count
        }
        return OfflineGardenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Online{
            GardenList = OnlineGardenList
            let cell = tableView.dequeueReusableCell(withIdentifier: "OnlineGardenCell", for:indexPath) as! OnlineGardenTVC
            cell.gardenImage.image = UIImage(named: "gardenImageBlank.png")
            cell.gardenLabel.text = GardenList[indexPath.row]?.gardenName ?? "MyGarden"
            cell.deleteButton.addTarget(self, action: #selector(GardenInterface.deleteGarden), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            return (cell)
        } else {
            GardenList = OfflineGardenList
            let cell = tableView.dequeueReusableCell(withIdentifier: "gardenCell", for:indexPath) as! GardenTableViewCell
            cell.gardenImage.image = UIImage(named: "gardenImageBlank.png")
            cell.gardenLabel.text = GardenList[indexPath.row]?.gardenName ?? "MyGarden"
            cell.deleteButton.addTarget(self, action: #selector(GardenInterface.deleteGarden), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            cell.postButton.addTarget(self, action: #selector(GardenInterface.postGarden), for: .touchUpInside)
            cell.postButton.tag = indexPath.row
            return (cell)
        }
     }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gardenIndex = indexPath.row
        performSegue(withIdentifier: "GardenProfile", sender: self)
    }
    
    @IBAction func handleLogout(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var emptyGardenLabel: UILabel!
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var segControl : UISegmentedControl!
    var gardenIndex:Int?
    var Online:Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 248.0/255.0, green: 1, blue: 210/255, alpha:1)
        self.tableView.rowHeight = 120.0
        // Do any additional setup after loading the view.
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()

   
    }
    
    @objc func postGarden(sender: UIButton){
        
        //Write Garden into Firebase
        
        let passedIndex = sender.tag
        //Assign Garden inside array with ID
        if !(OfflineGardenList[passedIndex]?.getOnlineState())! {
            print("Posting")
            OfflineGardenList[passedIndex]?.setIsOnline(state: true)
            //Assign Attribute into garden
            let garden = GardenList[passedIndex]?.gardenName
            let address = GardenList[passedIndex]?.address
            let gardenID = self.ref.child("Gardens").childByAutoId().key
            OfflineGardenList[passedIndex]?.gardenID=gardenID
            
            self.ref.child("Gardens/\(gardenID)/gardenName").setValue(garden)
            //self.ref.child("Gardens/\(gardenID)/Crops").setValue()
            self.ref.child("Gardens/\(gardenID)/Address").setValue(address)
            
            //Save gardenID into the user profile
            guard let userid=Auth.auth().currentUser?.uid else {return}
            let gardenRef=self.ref.child("Users/\(userid)/Gardens").child(gardenID)
            print(gardenID)
            gardenRef.setValue(true)
            
            if let numOfCrops = OfflineGardenList[passedIndex]?.getSize() {
                print("Adding Crops")
                for i in 0..<numOfCrops{
                    //let gardenID=GardenList[gardenIndex]?.gardenID
                    let cropname = OfflineGardenList[passedIndex]?.cropProfile[i]?.GetCropName()
                    let profName = OfflineGardenList[passedIndex]?.cropProfile[i]?.profName
                    let cropRef=self.ref.child("Gardens/\(gardenID)/CropList").childByAutoId()
                    cropRef.child("CropName").setValue(cropname)
                    cropRef.child("ProfName").setValue(profName)
                    print("Crop added")
                }
            }
        } else {
            print("Garden Already Posted")
        }
    }
    
    //Delete a selected garden
    @objc func deleteGarden(sender: UIButton){
        let passedIndex = sender.tag
        
        // Create Alert Message
        let alert = UIAlertController(title: "Delete Garden?", message: GardenList[passedIndex]?.gardenName, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            print("DELETE")
            if self.Online{
                let gardenID=OnlineGardenList[passedIndex]?.gardenID
                self.RemoveGardenFromFB(gardenID!)
                OnlineGardenList.remove(at: passedIndex)
            } else {
                OfflineGardenList.remove(at: passedIndex)
            }
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            print("no delete")
        }))
        self.present(alert, animated:true, completion:nil)
    }
    
    func RemoveGardenFromFB(_ id:String){
        let GardenRef=ref.child("Gardens/\(id)")
        GardenRef.removeValue()
        //remove child with the matching gardenID
        print("Garden Removed")
        //remove garden from Users
        let userid=Auth.auth().currentUser?.uid
        let UserGardenRef=ref.child("Users/\(userid)/Gardens/\(id)")
        UserGardenRef.removeValue()
        
    }
    
    
    func GetOnlineGardens(){
        //Create a set of gardenID belongs to user
        var gardenSet=[String]()
        guard let userid=Auth.auth().currentUser?.uid else{return}
        print(userid)
        let myGardenRef=self.ref.child("Users/\(userid)/Gardens")
        myGardenRef.observe(.value, with: {(snap) in
            for id in snap.children.allObjects as! [DataSnapshot]{
                print(id.key)
                gardenSet.append(id.key)
            }
        })
        
        //retrieve garden that the user is participating from Firebase
        let gardenref=self.ref.child("Gardens")
        gardenref.observe(.value, with: {(snapshot) in
            if snapshot.childrenCount>0{
                for garden in snapshot.children.allObjects as! [DataSnapshot]{
                    // if gardenSet.contains(garden.key)
                    if gardenSet.contains(garden.key)
                    {
                        let gardenObject=garden.value as? [String: AnyObject]
                        let gardenname=gardenObject?["gardenName"]
                        print(gardenname!)
                        let address=gardenObject?["Address"]
                        let newGarden=MyGarden(Name: gardenname as! String, Address: address as! String, GardenID:garden.key)
                        OnlineGardenList.append(newGarden)
                    }
                }
                self.tableView.reloadData()
            }})
    }
    
    // Alternate tableview contents of displaying online profiles and offline profiles
    @IBAction func ChangeOfflineOnline(_ sender : Any){
        if segControl.selectedSegmentIndex == 0 {
            print("Offline")
            self.Online = false
            self.tableView.reloadData()
        }
        
        if segControl.selectedSegmentIndex == 1 {
            print("Online")
            self.Online = true
            OnlineGardenList.removeAll()
            GetOnlineGardens()
        }
    }

    //Pass gardenIndex to the next viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GardenProfile")  {
            let nextController=segue.destination as!GardenCropList
            nextController.gardenIndex = gardenIndex!
            nextController.Online=self.Online
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
