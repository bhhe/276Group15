//
//  MainVC.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-16.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user=Auth.auth().currentUser{
            self.performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
