//
//  CropProfileViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-03.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class CropProfileViewController: UIViewController {
    
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var notifText: UITextField!
    @IBOutlet weak var waterAmount: UILabel!
    @IBOutlet weak var plantCare: UILabel!
    @IBOutlet weak var feeding: UILabel!
    @IBOutlet weak var spacing: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var harvesting: UILabel!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var calcBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    
    var gardenIndex = 0
    var myIndex = 0
    var crop: CropProfile!
    var garden:MyGarden?
    var waterAmll:Double = 0.00
    let ref = Database.database().reference()
    
    
    override func viewDidLoad() {
        notificationBtn.layer.cornerRadius = 5
        calcBtn.layer.cornerRadius = 5
        resetBtn.layer.cornerRadius = 5
        
        super.viewDidLoad()
        let midGrowth = crop?.GetWateringVariable().getMid()
        weather.UpdateWaterRequirements(coEfficient: midGrowth!)
        //crop = (GardenList[gardenIndex]?.cropProfile[myIndex])!
        //cropName.topItem?.title = crop.GetCropName()
        plantCare.text = "Plant Care: " + (crop?.getCare())!
        feeding.text = "Feeding: " + (crop?.getFeeding())!
        spacing.text = "Spacing: " + (crop?.getSpacing())!
        note.text = "Note: " + (crop?.getNotes())!
        harvesting.text = "Harvesting: " + (crop?.getHarvesting())!
        cropImage.image = UIImage(named: (crop?.getImage())!)
        waterAmount.text = String(waterAmll) + " (ml)/ day"
        
        self.title = crop?.GetCropName();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    // Dispose of any resources that can be recreated.
    func isStringInt(theString : String) -> Bool{
        return Int(theString) != nil
    }
    
    /*
     Displaying notification for seconds for demonstration purposes
     */
    @IBAction func setNotification(_ sender: Any) {
        calculateWater(sender)
        var notifMsg = "You need to water " + String(waterAmll) + " ml today."
        // Used this to test notification -- should give notification after 1 minute
        if isStringInt(theString : notifText.text!){
            crop?.setNotification(Hours: Int(notifText.text!)!,msg : notifMsg)
        }
    }
    
    @IBAction func calculateWater(_ sender: Any) {
        let midGrowth = crop?.GetWateringVariable().getMid()
        weather.UpdateWaterRequirements(coEfficient: midGrowth!)
        waterAmll = Double(weather.GetWaterRequirements())/10*crop.surfaceArea!
        waterAmll = Double( round(100*waterAmll)/100)
        viewDidLoad()
    }
    
    @IBAction func ResetSize(_ sender: Any) {
        //it pops up a screen asking user for a new XY input for calcualting the surfaceArea.
        ResetPlotSize()
    }
    
    func ResetPlotSize(){
        let alertController = UIAlertController(title: "New Plot Size", message: "Enter new length and width", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Length"
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Width"
        }
        
        let changeAction = UIAlertAction(title: "Change", style: .default) { (_) in
            
            let lengthField = alertController.textFields![0]
            let widthField = alertController.textFields![1]
            
            
            let length = lengthField.text
            let width = widthField.text
            
            
            if length != "" && width != "" {
                let gardenID = self.garden?.gardenID
                let cropRef = self.ref.child("Gardens/\(gardenID!)/CropList/\(self.crop.cropID!)/SurfaceArea")
                let plotX = (length! as NSString).doubleValue
                let plotY = (width! as NSString).doubleValue
                self.crop.coreData?.plotLength = Double(plotX)
                self.crop.coreData?.plotWidth = Double(plotY)
                let newArea=plotX*plotY
                cropRef.setValue(newArea)
                self.crop.surfaceArea = newArea
                
            } else {
                alertController.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Missing Entries", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    alert.dismiss(animated:true, completion:nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(changeAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
