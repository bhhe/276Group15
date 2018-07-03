//
//  SecondViewController.swift
//  CropBook
//
//  Created by jon on 2018-06-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

var lib = CropLibrary(jsonName: "cropdata")

class CropLibraryController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Page 2 Loaded")
        
        // Used this to test notification -- should give notification after 1 minute
        let notification = Notifications()
        notification.setHour(Hour : Calendar.current.component(.hour, from: Date()))
        notification.setMinute(Minute : Calendar.current.component(.minute, from: Date())+1)
        notification.setWeekDay(Day: 1)
        notification.Schedule()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


