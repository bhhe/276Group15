//
//  CropSetupViewController.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CropSetupViewController: UIViewController {

    var gardenIndex:Int?
    
    @IBOutlet weak var CropTypeTF: UITextField!
    @IBOutlet weak var CropNameTF: UITextField!
    
    @IBAction func CreateButton(_ sender: Any) {
        if let cropType=CropTypeTF.text,
            let cropName=CropNameTF.text{
         // hardcoding crop id and watering variable, function in iteration 2 and 3.
            let newCrop=CropProfile(cropid: 0, cropName: cropName, cropType: cropType, wateringVariable: 0.0)
            GardenList[gardenIndex!]?.cropProfile.append(newCrop)
            
        }
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var nextController=segue.destination as!GardenCropList
        
        nextController.gardenIndex=gardenIndex
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
