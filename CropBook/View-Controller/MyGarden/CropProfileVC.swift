//
//  CropProfileViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-03.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CropProfileViewController: UIViewController {
    
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var notifText: UITextField!
    @IBOutlet weak var waterAmount: UILabel!
    @IBOutlet weak var plantCare: UILabel!
    @IBOutlet weak var feeding: UILabel!
    @IBOutlet weak var spacing: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var harvesting: UILabel!
    
    var gardenIndex = 0
    var myIndex = 0
    var crop: CropProfile!
    
    var waterAmll = Float(0)
    
    
    override func viewDidLoad() {
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
        waterAmount.text = String(waterAmll) + " (mm)/ day"
        
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
        var notifMsg = "You need to water " + String(waterAmll) + " mm today."
        // Used this to test notification -- should give notification after 1 minute
        if isStringInt(theString : notifText.text!){
            crop?.setNotification(Seconds: Int(notifText.text!)!,msg : notifMsg)
        }
    }
    
    @IBAction func calculateWater(_ sender: Any) {
        let midGrowth = crop?.GetWateringVariable().getMid()
        weather.UpdateWaterRequirements(coEfficient: midGrowth!)
        waterAmll = Float(weather.GetWaterRequirements())
        viewDidLoad()
    }
    
}
