//
//  GardenInterface.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import MultiSelectSegmentedControl

class GardenCropList: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addCropButton: UIButton!
    
    var managedObjectContext : NSManagedObjectContext!
    var myIndex=0
    var gardenIndex = 0
    var myGarden: MyGarden!
    var cropList: [CropProfile?]?
    var Online:Bool?
    var isExtended: Int?
    let ref=Database.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor(red: 248.0/255.0, green: 1, blue: 210/255, alpha:1)
        self.view.bringSubview(toFront: self.addCropButton)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if self.Online! {
            // Ensure Menu Button is enabled
            self.menuButton.tintColor = .black
            self.menuButton.isEnabled = true
            
            //remove all crop before loading from firebase
            self.myGarden = SHARED_GARDEN_LIST[gardenIndex]
            self.myGarden.cropProfile.removeAll()
            //self.cropList?.removeAll()
            //retrieve Crops from the Firebase
            let gardenID = self.myGarden.gardenID
            let GardenRef = ref.child("Gardens/\(gardenID!)/CropList")
            GardenRef.observeSingleEvent(of: .value, with: {(snapshot) in
                for child in snapshot.children.allObjects as![DataSnapshot]{
                    print(child)
                    let cropObject=child.value as? [String:AnyObject]
                    let cropname=cropObject?["CropName"]
                    let area=cropObject?["SurfaceArea"]
                    let cropinfo=lib.searchByName(cropName: cropname as! String)
                    let newCrop=CropProfile(cropInfo: cropinfo!, profName: cropname as! String)
                    newCrop.cropID=child.key
                    newCrop.surfaceArea = area as? Double
                    print(newCrop.surfaceArea)
                    print(child.key)
                    _ = self.myGarden.AddCrop(New: newCrop)
                }
                self.cropList = self.myGarden.cropProfile
                self.tableView.reloadData()
            })
        }
        else {
            // Hide and Disable Menu Button
            self.menuButton.tintColor = .clear
            self.menuButton.isEnabled = false
            
            // Load local garden
            self.myGarden = MY_GARDEN
            self.cropList = MY_GARDEN.cropProfile
        }
        //self.myGarden = GardenList[gardenIndex]
        //self.cropList = GardenList[gardenIndex]?.cropProfile
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
            // Make regular Crop Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "cropCell", for:indexPath) as! CropTableViewCell
            let name: String? = cellData.cropName
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = UIColor(red: 202.0/255.0, green: 225/255, blue: 200/255, alpha:1)
            } else {
                cell.backgroundColor = UIColor(red: 244.0/255.0, green: 254/255, blue: 217/255, alpha:1)
            }
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
            
            if let surface = cropList?[indexPath.row - 1]?.surfaceArea {
                expandedCell.plotSize.text = String(surface)
            } else {
                expandedCell.plotSize.text = ""
                expandedCell.plotSize.placeholder = "cm^2"
            }
            expandedCell.waterAmount.text = "0.0 mL"

            if !self.Online!{
                let indexSet = NSMutableIndexSet()
                let array = cropList?[self.isExtended!]?.notif.scheduleDays
                expandedCell.timeField.placeholder = MY_GARDEN.cropProfile[self.isExtended!]?.notif.getTimeString()
                array?.forEach(indexSet.add)
                expandedCell.selectDays.selectedSegmentIndexes = indexSet as IndexSet?
                expandedCell.enableReminder.setOn((MY_GARDEN.cropProfile[self.isExtended!]?.notif.enabled)!, animated: true)
            }
            expandedCell.waterButton.addTarget(self, action: #selector(GardenCropList.updateWaterAmount), for: .touchUpInside)
            expandedCell.enableReminder.addTarget(self, action: #selector(GardenCropList.updateScheduleEnabled), for: .valueChanged)
            expandedCell.selectDays.addTarget(self, action: #selector(GardenCropList.updateScheduleWeekdays), for: .valueChanged)
            expandedCell.timeField.addTarget(self, action: #selector(GardenCropList.updateScheduleTime), for: .editingDidEnd)
            expandedCell.plotSize.addTarget(self, action: #selector(GardenCropList.updatePlotSize), for: .editingDidEnd)
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
    
    @objc func updateScheduleTime(sender: UITextField){
        let timeString = sender.text!
        
        // Scrapes textfield and converts time string into int values for hour and minute
        for (index, char) in timeString.enumerated() {
            if char == ":"{
                var hourIndex = timeString.index(timeString.startIndex, offsetBy: index)
                var hour = Int(timeString.prefix(upTo: hourIndex))!
                
                hourIndex = timeString.index(timeString.startIndex, offsetBy: index + 1)
                let minuteIndex = timeString.index(hourIndex, offsetBy: index + 2)
                let minute = (timeString[hourIndex..<minuteIndex] as NSString).intValue
                
                let AM_PM = timeString.index(timeString.endIndex, offsetBy: -2)
                if timeString.suffix(from: AM_PM) == "PM" && hour != 12{
                    hour += 12
                } else if timeString.suffix(from: AM_PM) == "AM" && hour == 12 {
                    hour += 12
                }
                
                MY_GARDEN.cropProfile[self.isExtended!]?.notif.setTimeString(time: timeString)
                MY_GARDEN.cropProfile[self.isExtended!]?.notif.setTimeOfDay(Hour: hour, Minute: Int(minute))
                let message = "Remember to water your " + (MY_GARDEN.cropProfile[self.isExtended!]?.GetCropName())! + "!"
                MY_GARDEN.cropProfile[self.isExtended!]?.notif.scheduleEachWeekday(msg: message)
                break
            }
        }
    }
    
    @objc func updatePlotSize(sender: UITextField){
        if let newSize = sender.text {
            if !self.Online!{
                MY_GARDEN.cropProfile[self.isExtended!]?.setSurfaceArea(area: Double(newSize)!)
            } else {
                SHARED_GARDEN_LIST[self.gardenIndex]?.cropProfile[self.isExtended!]?.setSurfaceArea(area: Double(newSize)!)
            }
        }
    }
    
    @objc func updateScheduleEnabled(sender: UISwitch){
        if !self.Online!{
            MY_GARDEN.cropProfile[self.isExtended!]?.notif.enabled = sender.isOn
            if !sender.isOn{
                MY_GARDEN.cropProfile[self.isExtended!]?.notif.disableNotifications()
            } else {
                let message = "Remember to water your " + (MY_GARDEN.cropProfile[self.isExtended!]?.GetCropName())! + "!"
                MY_GARDEN.cropProfile[self.isExtended!]?.notif.scheduleEachWeekday(msg: message)
            }
        }
    }
    
    // Water Button is Clicked
    @objc func updateWaterAmount(sender: UIButton){
        
        let midGrowth = cropList?[self.isExtended!]?.GetWateringVariable().getMid()
        weather.UpdateWaterRequirements(coEfficient: midGrowth!)
        
        let indexPath = IndexPath(row: self.isExtended! + 1, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpandedCropCell else {return}
        
        if cell.plotSize.text != "" {
            if let surfaceArea = cropList?[self.isExtended!]?.surfaceArea{
                var waterAmnt = Double(weather.GetWaterRequirements())/10*surfaceArea
                waterAmnt = Double( round(100*waterAmnt)/100)
                cell.waterAmount.text = String(waterAmnt) + " mL"
            } else {
                print("No surface Area")
            }
        }
    }
    
    // Looks at multisegmented control in extended TableViewCell
    // Sets the days of the week for notifications
    @objc func updateScheduleWeekdays(sender: MultiSelectSegmentedControl){
        let selectedIndices = Array(sender.selectedSegmentIndexes)
        if !self.Online!{
            MY_GARDEN.cropProfile[self.isExtended!]?.notif.setScheduleDays(days: selectedIndices)
            let message = "Remember to water your " + (MY_GARDEN.cropProfile[self.isExtended!]?.GetCropName())! + "!"
            MY_GARDEN.cropProfile[self.isExtended!]?.notif.scheduleEachWeekday(msg: message)
        }
    }
    
    //Delete a selected crop from a garden
    @objc func deleteCrop(sender: UIButton){
        let passedIndex = sender.tag
        
        let alert = UIAlertController(title: "Remove Crop from Garden?", message: myGarden.cropProfile[passedIndex]?.GetCropName(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            
            if passedIndex == self.isExtended{
                self.contractCell(tableView: self.tableView, index: passedIndex)
            }
            if self.Online!{
                let cropid=self.myGarden.cropProfile[passedIndex]?.cropID
                self.RemoveCropFromFB(cropid!)
                //print(cropid)
            }else{
                let core = self.myGarden.cropProfile[passedIndex]?.coreData
                self.removeFromCore(cropCore: core!)
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
        self.tableView.reloadData()
        self.deleteConfirmed()
    }
    
    func deleteConfirmed(){
        let alert = UIAlertController(title: "Crop Removed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func RemoveCropFromFB(_ id:String){
        let gardenID=myGarden.gardenID
        let CropRef=ref.child("Gardens/\(gardenID!)/CropList/\(id)")
        CropRef.removeValue()
        print("Removed!")
    }
    
    func removeFromCore(cropCore : NSManagedObject){
        PersistenceService.context.delete(cropCore)
        PersistenceService.saveContext()
        print("Deleted")
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
    
    // Prepare next viewcontrollers for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CropProfileSegue"{
            let receiverVC = segue.destination as! CropProfileViewController
            if self.isExtended != nil {
                if self.myIndex > self.isExtended! {
                    receiverVC.crop = myGarden.cropProfile[myIndex - 1]
                    receiverVC.myIndex = self.myIndex - 1
                }
            }
            receiverVC.crop = myGarden.cropProfile[myIndex]
            receiverVC.myIndex = self.myIndex
            receiverVC.garden = myGarden
        
        }else if segue.identifier == "createCrop"{
            let receiverVC = segue.destination as! CropCreateVC
            receiverVC.gardenIndex = gardenIndex
            receiverVC.Online = self.Online
        }
        else if segue.identifier == "showMap"{
            let receiverVC = segue.destination as!MapVC
            receiverVC.gardenIndex=gardenIndex
            receiverVC.garden=myGarden
            
        }
        else if segue.identifier == "showMember"{
            let receiverVC = segue.destination as!MemberList
            
            receiverVC.garden=myGarden
            
        }
    }
}
