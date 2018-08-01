//
//  CInfoViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CInfoViewController: UIViewController {
    
    @IBOutlet weak var cropType: UILabel!
    @IBOutlet weak var cropImage: UIImageView!
    @IBOutlet weak var coefficients: UILabel!
    @IBOutlet weak var sunExposure: UILabel!
    @IBOutlet weak var soilType: UILabel!
    @IBOutlet weak var soilpH: UILabel!
    @IBOutlet weak var plantCare: UILabel!
    @IBOutlet weak var feeding: UILabel!
    @IBOutlet weak var spacing: UILabel!
    @IBOutlet weak var note: UILabel!
    @IBOutlet weak var harvesting: UILabel!
    var cropFound : CropInfo = CropInfo()
    @IBOutlet weak var cropName: UILabel!
    override func viewDidLoad() {
        
        cropName.text = "Crop Name: " + cropFound.getName()
        cropImage.image = UIImage(named : cropFound.getImage())
        cropType.text = "Crop Type: " + cropFound.getType()
        coefficients.text = cropFound.getCoEff().getString()
        sunExposure.text = "Sun Exposure: " + cropFound.getSunExposure()
        soilType.text = "Soil Type: " + cropFound.getSoilType()
        soilpH.text = "Soil pH: " + cropFound.getSoilpH()
        plantCare.text = "Plant Care: " + cropFound.getCare()
        feeding.text = "Feeding: " + cropFound.getFeeding()
        spacing.text = "Spacing: " + cropFound.getSpacing()
        note.text = "Note: " + cropFound.getNotes()
        harvesting.text = "Harvesting: " + cropFound.getHarvesting()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
