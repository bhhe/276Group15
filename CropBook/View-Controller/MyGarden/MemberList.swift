//
//  MemberList.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-29.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class MemberList: UIViewController ,UITableViewDelegate, UITableViewDataSource{
   

    @IBOutlet weak var lastWateredTime: UILabel!
    @IBOutlet weak var memberTable: UITableView!
    @IBOutlet weak var wateredButton: UIButton!
    let ref=Database.database().reference()
    var garden:MyGarden?
    var memberList = [String]()
    var lastWateredIndex:Int?
    var owner:String?
    //start by retrieving members from the garden.
    
    func getMembers(){
        guard let garden = garden  else{return}
        let memberRef=ref.child("Gardens/\(garden.gardenID!)/members")
        memberRef.observe(.value, with: {(snap) in
            for id in snap.children.allObjects as! [DataSnapshot]{
                if let member=id.value as? String{
                self.memberList.append(member)
                }
                
            }
        })
        print(memberList.count)
        
        // also we need to retrieve who watered it last
        let lastWateredRef = ref.child("Gardens/\(garden.gardenID!)/lastWatered")
        lastWateredRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let PersonWatered = snapshot.value as? String{
                self.lastWateredIndex = self.memberList.index(of: PersonWatered)
            }
            let timeSnapshot = snapshot.childSnapshot(forPath: "time")
            if let time = timeSnapshot.value as? String{
                self.lastWateredTime.text = "Last watered at \(time)"
            }
            
            
        })
        
        // then we need to get the last watered time
        memberTable.reloadData()
        
    
    }
    
   
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.memberList.count
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "memberCell")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {cell.textLabel?.text = self.memberList[indexPath.row]} )
        //display a check mark if someone watered it
        if let lastWateredIndex = lastWateredIndex{
            if indexPath.row == lastWateredIndex{
                cell.accessoryType = UITableViewCellAccessoryType.checkmark
                
            }
        }
        //display owner of the garden
        
        if memberList[indexPath.row] == self.owner {
            cell.detailTextLabel?.text = "Owner"
            print("success!!!")
        }else{
            cell.detailTextLabel?.text = "Members"
        }
        cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!
            , size : 20)
        cell.detailTextLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!
            , size : 14)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func getOwner(){
        
        guard let garden = garden  else{
            print ("Error no garden 1")
            return
        }
        let ownerRef = ref.child("Gardens/\(garden.gardenID!)/Owner")
        ownerRef.observeSingleEvent(of: .value, with: {(snapshot) in
            print(snapshot)
            self.owner = snapshot.value as? String
            print(self.owner!)
        })
        
    }
    
    //this button will update the LastWatered field to the currentUser.
    @IBAction func updateLastWatered(_ sender: Any) {
        let userEmail = Auth.auth().currentUser?.email
        //we use the email to scan through the member list we have to update lastWatered person
       
        if let userRow =  memberList.index(of: userEmail!){
            print(userRow)
            self.lastWateredIndex = userRow
        }
        
        guard let garden = garden  else{return}
        let gardenRef = ref.child("Gardens/\(garden.gardenID!)/lastWatered")
        gardenRef.child("user").setValue(userEmail)
        let timeRef = gardenRef.child("time")
        let currentTime = getTime()
        timeRef.setValue(currentTime)
        self.lastWateredTime.text = "Last watered at \(currentTime)"

        memberTable.reloadData()
    }
    
    func getTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = String(format: "%02d",calendar.component(.hour, from: date))
        let minutes = String(format: "%02d",calendar.component(.minute, from: date))
        
        let day = String(format: "%02d",calendar.component(.day, from: date))
        let month = String(format: "%02d",calendar.component(.month, from: date))
        let year = calendar.component(.year, from: date)
        
        let time = "\(hour):\(minutes) on \(month)/\(day)/\(year)"
        return time
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //the next couple line of code make a circle button
        wateredButton.backgroundColor = UIColor.blue
        wateredButton.layer.cornerRadius = wateredButton.frame.height/2
        wateredButton.setTitleColor(UIColor.white, for: .normal)
        
        getOwner()
        getMembers()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
         memberTable.reloadData()
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
