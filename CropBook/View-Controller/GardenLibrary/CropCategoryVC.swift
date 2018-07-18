//
//  CropCategoryViewController.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CropCategoryViewController: UIViewController {

    @IBOutlet weak var FruitBTN: UIButton!
    @IBOutlet weak var VeggieBTN: UIButton!
    @IBOutlet weak var WheatBTN: UIButton!
    @IBOutlet weak var AllBTN: UIButton!

    
    var gardenIndex:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        FruitBTN.layer.cornerRadius = 7;
        VeggieBTN.layer.cornerRadius = 7;
        WheatBTN.layer.cornerRadius = 7;
        AllBTN.layer.cornerRadius = 7;
        // Do any additional setup after loading the view.
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
