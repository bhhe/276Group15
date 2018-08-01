//
//  CtgyViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CtgyViewController: UIViewController {

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var wheatButton: UIButton!
    @IBOutlet weak var veggieButton: UIButton!
    @IBOutlet weak var fruitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fruitButton.layer.cornerRadius = 7;
        veggieButton.layer.cornerRadius = 7;
        wheatButton.layer.cornerRadius = 7;
        allButton.layer.cornerRadius = 7;
    }
    
    @IBAction func selectCategory(sender : UIButton!){
        if sender == fruitButton{
            ctgyLib = lib.getFruitLibrary()
        }else if sender == veggieButton{
            ctgyLib = lib.getVeggieLibrary()
        }else if sender == wheatButton{
            ctgyLib = lib.wheatDatabase
        }else{
            ctgyLib = lib.getMainLibrary()
        }
    }

}
