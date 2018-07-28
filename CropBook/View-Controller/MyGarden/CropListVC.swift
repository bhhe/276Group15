//
//  GardenInterface.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase


class GardenCropList: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    var myIndex=0
    var gardenIndex = 0
    var myGarden: MyGarden!
    var cropList: [CropProfile?]?
    var Online:Bool?
    var isExtended: Int?
    let ref=Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.rowHeight = 120.0
        self.tableView.backgroundColor = UIColor(red: 248.0/255.0, green: 1, blue: 210/255, alpha:1)
        
        // Do any additional setup after loading the view.
        self.myGarden = GardenList[gardenIndex]
        if self.Online! {
            //remove all crop before loading from firebase
            self.myGarden.cropProfile.removeAll()
            //retrieve Crops from the Firebase
            let gardenID = self.myGarden.gardenID
            let GardenRef = ref.child("Gardens/\(gardenID!)/CropList")
            GardenRef.observe(.value, with: {(snapshot) in
                for child in snapshot.children.allObjects as![DataSnapshot]{
                    let cropObject=child.value as? [String:AnyObject]
                    let cropname=cropObject?["CropName"]
                    let profname=cropObject?["ProfName"]
                    let cropinfo=lib.searchByName(cropName: cropname as! String)
                    let newCrop=CropProfile(cropInfo: cropinfo!, profName: cropname as! String)
                    newCrop.cropID=child.key
                    print(child.key)
                    self.myGarden.AddCrop(New: newCrop)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.myGarden = GardenList[gardenIndex]
        self.cropList = GardenList[gardenIndex]?.cropProfile
        self.isExtended = nil
        self.tableView.reloadData()
        
        
        self.title = myGarden?.gardenName;
        print("Number of Crops = ", myGarden!.getSize())
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (cropList?[indexPath.row]) != nil {
            return 120
        } else {
            return 155
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = cropList {
            return data.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellData = cropList?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cropCell", for:indexPath) as! CropTableViewCell
            let name: String? = cellData.cropName
            cell.cropLabel?.text = name
            cell.cropImage?.image = UIImage(named: (cellData.getImage()))
            cell.deleteButton.addTarget(self, action: #selector(GardenCropList.deleteCrop), for: .touchUpInside)
            cell.deleteButton.tag = indexPath.row
            cell.detailsButton.addTarget(self, action: #selector(GardenCropList.openCropDetails), for: .touchUpInside)
            cell.detailsButton.tag = indexPath.row
            return cell
        } else{
            //Make Expanded cell
            let expandedCell = tableView.dequeueReusableCell(withIdentifier: "ExpandedCropCell", for:indexPath) as! ExpandedCropCell
            return expandedCell
        }
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        myIndex = indexPath.row
        
        if (indexPath.row + 1 >= (cropList?.count)!){
            expandCell(tableView: tableView, index: indexPath.row)
        } else {
            if (cropList?[indexPath.row + 1] != nil) {
                expandCell(tableView: tableView, index: myIndex)
            } else {
                contractCell(tableView: tableView, index: myIndex)
            }
        }
    }
    
    @objc func openCropDetails(sender: UIButton){
        self.myIndex = sender.tag
        performSegue(withIdentifier: "CropProfileSegue", sender: self)
    }
    
    //Delete a selected garden
    @objc func deleteCrop(sender: UIButton){
        let passedIndex = sender.tag
        
        let alert = UIAlertController(title: "Remove Crop from Garden?", message: myGarden.cropProfile[passedIndex]?.GetCropName(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            print("DELETE")
            
            if self.myGarden.getOnlineState(){
                let cropid=self.myGarden.cropProfile[passedIndex]?.cropID
                self.RemoveCropFromFB(cropid!)
            }
            self.cropList?.remove(at: passedIndex)
            self.myGarden.cropProfile.remove(at: passedIndex)
            self.tableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            print("no delete")
        }))
        self.present(alert, animated:true, completion:nil)
    }
    
    func RemoveCropFromFB(_ id:String){
        let gardenID=myGarden.gardenID
        let CropRef=ref.child("Gardens/\(gardenID)/CropList/\(id)")
        CropRef.removeValue()
        print("Removed!")
    }
    
    /*  Expand cell at given index  */
    private func expandCell(tableView: UITableView, index: Int) {
        // Expand Cell -> add ExpansionCells
        if (cropList?[index]) != nil {
            // If a cell is currently expanded, close it before opening another
            if let Extended = self.isExtended{
                cropList?.remove(at: Extended + 1)
                if (index > Extended){
                    // Selected cell is greater than currently expanded cell
                    tableView.deleteRows(at: [NSIndexPath(row: Extended+1, section: 0) as IndexPath], with: .top)
                    self.isExtended = index - 1
                    cropList?.insert(nil, at: index)
                    tableView.insertRows(at: [NSIndexPath(row: index, section: 0) as IndexPath] , with: .top)
                } else if (index<Extended) {
                    // Selected cell is less than currently expanded cell
                    tableView.deleteRows(at: [NSIndexPath(row: Extended+1, section: 0) as IndexPath], with: .bottom)
                    self.isExtended = index
                    cropList?.insert(nil, at: index+1)
                    tableView.insertRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath] , with: .top)
                }
            } else {
                // If no cell is currently expanded, just expand
                cropList?.insert(nil, at: index + 1)
                self.isExtended = index
                tableView.insertRows(at: [NSIndexPath(row: index + 1, section: 0) as IndexPath] , with: .top)
            }
        }
    }
    
    /*  Contract cell at given index    */
    private func contractCell(tableView: UITableView, index: Int) {
        if (cropList?[index]) != nil {
            cropList?.remove(at: index+1)
            self.isExtended = nil
            tableView.deleteRows(at: [NSIndexPath(row: index+1, section: 0) as IndexPath], with: .top)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CropProfileSegue"{
            let receiverVC = segue.destination as! CropProfileViewController
            receiverVC.gardenIndex = self.gardenIndex
            receiverVC.myIndex = self.myIndex
            
        }else if segue.identifier == "createCrop"{
            let receiverVC = segue.destination as! CropCreateVC
            receiverVC.gardenIndex = gardenIndex
            receiverVC.Online = self.Online
        }
    }
}
