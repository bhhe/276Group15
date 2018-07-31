//
//  ApplyVC.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-18.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

import Firebase
import FirebaseDatabase
import FirebaseAuth

class ApplyVC: UIViewController {
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var infoText: UITextView!
    
    var validApply = true
    var postRef : DatabaseReference?
    var uid = Auth.auth().currentUser?.uid
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        let email = Auth.auth().currentUser?.email as! String
        let uRef = postRef?.child("Requests").child(uid!)
        uRef?.child("name").setValue(nameField.text)
        uRef?.child("info").setValue(infoText.text)
        uRef?.child("email").setValue(email)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute:{
            self.performSegue(withIdentifier: "unwindPost", sender: self)})
    }
    
}
