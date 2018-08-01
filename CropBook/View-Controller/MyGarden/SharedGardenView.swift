//
//  SharedGardenView.swift
//  CropBook
//
//  Created by jon on 2018-07-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase
class SharedGardenView: UIViewController, UITableViewDataSource, UITableViewDelegate{

    @IBOutlet weak var tableView : UITableView!
    weak var delegate: gardenButtonClicked?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "SharedGardenCell", bundle: nil), forCellReuseIdentifier: "sharedGardenCell")
        tableView.backgroundColor = UIColor(red: 248.0/255.0, green: 1, blue: 210/255, alpha:1)
        tableView.rowHeight = 120.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.GetOnlineGardens()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SHARED_GARDEN_LIST.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharedGardenCell", for:indexPath) as! SharedGardenCell
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 202.0/255.0, green: 225/255, blue: 200/255, alpha:1)
        } else {
            cell.backgroundColor = UIColor(red: 244.0/255.0, green: 254/255, blue: 217/255, alpha:1)
        }
        cell.gardenLabel.text = SHARED_GARDEN_LIST[indexPath.row]?.gardenName ?? "MyGarden"
        cell.mapButton.addTarget(self, action: #selector(SharedGardenView.openMap), for: .touchUpInside)
        cell.mapButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(SharedGardenView.createDeleteMessage), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.openSharedCrops(index: indexPath.row)
    }
    
    func GetOnlineGardens(){
        //Create a set of gardenID belongs to user
        SHARED_GARDEN_LIST.removeAll()
        let ref=Database.database().reference()
        var gardenSet=[String]()
        guard let userid=Auth.auth().currentUser?.uid else{return}
        print(userid)
        let myGardenRef=ref.child("Users/\(userid)/Gardens")
        myGardenRef.observe(.value, with: {(snap) in
            for id in snap.children.allObjects as! [DataSnapshot]{
                print(id.key)
                gardenSet.append(id.key)
            }
        })
        
        //retrieve garden that the user is participating from Firebase
        let gardenref = ref.child("Gardens")
        gardenref.observeSingleEvent(of: .value, with: {(snapshot) in
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
                        SHARED_GARDEN_LIST.append(newGarden)
                    }
                }
                self.tableView.reloadData()
            }})
    }
    
    // Make sure user wants to remove the Garden
    @objc func createDeleteMessage(sender: UIButton){
        // Create Alert Message
        let alert = UIAlertController(title: "Remove Garden?", message: SHARED_GARDEN_LIST[sender.tag]?.gardenName, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            self.deleteGarden(index: sender.tag)
            self.confirmationMessage()
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
        }))
        self.present(alert, animated:true, completion:nil)
    }
    
    // Delete Garden from SHARED_GARDEN_LIST and from FireBase
    func deleteGarden(index: Int){
        let ref = Database.database().reference()
        let gardenID=SHARED_GARDEN_LIST[index]?.gardenID
        let GardenRef = ref.child("Gardens/\(gardenID!)")
        GardenRef.removeValue()
        //remove child with the matching gardenID
        print("Garden Removed")
        //remove garden from Users
        let userid=Auth.auth().currentUser?.uid
        let UserGardenRef=ref.child("Users/\(userid!)/Gardens/\(gardenID!)")
        UserGardenRef.removeValue()
        SHARED_GARDEN_LIST.remove(at: index)
    }
    
    func confirmationMessage(){
        let confirmation = UIAlertController(title: "Garden Removed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        confirmation.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            confirmation.dismiss(animated: true, completion: nil)
        }))
        self.present(confirmation, animated:true, completion:nil)
    }
    
    
    @objc func openMap(sender: UIButton){
        delegate?.openMap(index: sender.tag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
