//
//  acceptVC.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-18.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class acceptVC: UIViewController {

    var acptData : [AcceptData] = []
    
    override func viewDidLoad() {
        print(acptData.count)
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptPressed(_ sender: Any) {
        performSegue(withIdentifier: "unwindAccept", sender: self)
    }
}
