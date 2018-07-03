//
//  CropProfileViewController.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-03.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CropProfileViewController: UIViewController {
    @IBOutlet weak var cropNameLabel: UILabel!
    @IBOutlet weak var cropTypeLabel: UILabel!
    
    var gardenIndex:Int?
    var myIndex:Int?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        cropNameLabel.text=GardenList[gardenIndex!]?.cropProfile[myIndex!].cropName
        cropTypeLabel.text=GardenList[gardenIndex!]?.cropProfile[myIndex!].cropType
    }
        // Dispose of any resources that can be recreated.
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
