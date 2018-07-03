//
//  CInfoViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

//var lib = CropLibrary(jsonName : "cropdata")
class CInfoViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    var cropFound : CropInfo = CropInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = cropFound.getName()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
