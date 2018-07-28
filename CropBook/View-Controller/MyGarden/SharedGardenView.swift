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
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SHARED_GARDEN_LIST.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sharedGardenCell", for:indexPath) as! SharedGardenCell
        cell.gardenLabel.text = SHARED_GARDEN_LIST[indexPath.row]?.gardenName ?? "MyGarden"
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
                        SHARED_GARDEN_LIST.append(newGarden)
                    }
                }
                self.tableView.reloadData()
            }})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
