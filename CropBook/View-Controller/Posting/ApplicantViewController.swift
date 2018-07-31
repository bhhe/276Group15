//
//  ApplicantViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class ApplicantViewController: UIViewController {
    
    @IBOutlet weak var applicName: UILabel!
    @IBOutlet weak var applicInfo: UITextView!
    
    var appInfo = AcceptData()
    let ref =  Database.database().reference()
    var postId = ""
    var email : String?
    
    override func viewDidLoad() {
        applicName.text = appInfo.name
        applicInfo.text = appInfo.info
        applicInfo.isEditable = false
        print(appInfo.email)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func acceptApplicant(_ sender: Any) {
        let usrRef = ref.child("Users/\(appInfo.uId)/Gardens/\(appInfo.gardenId)")
        usrRef.setValue(false)
        
        let reqRef = ref.child("Posts/\(postId)/Requests/\(appInfo.uId)")
        reqRef.removeValue()
        
        let memsRef = ref.child("Gardens/\(appInfo.gardenId)/members")
        let memRef = memsRef.child("\(appInfo.uId)")
        memRef.setValue(appInfo.email!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.performSegue(withIdentifier: "unwindApp", sender: self)})
    }
    
    @IBAction func declineApplicant(_ sender: Any) {
        let reqRef = ref.child("Posts/\(postId)/Requests/\(appInfo.uId)")
        reqRef.removeValue()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{self.performSegue(withIdentifier: "unwindApp", sender: self)})
    }
    
}
