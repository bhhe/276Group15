//
//  CreateCropViewController.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CreateCropViewController: UIViewController {

    @IBOutlet weak var ByNameButton: UIButton!
    var gardenIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="Category"{
            var nextController=segue.destination as!CropCategoryViewController
            nextController.gardenIndex=gardenIndex
        }
        
        else if segue.identifier=="CropSetup"{
            var nextController=segue.destination as!CropSetupViewController
        nextController.gardenIndex=gardenIndex
        }
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
