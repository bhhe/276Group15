//
//  SignupVC.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-16.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class SignupVC: UIViewController {
    
    let ref=Database.database().reference()
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mySecret: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signupTapped(_ sender: Any) {
        guard let username=usernameField.text   else{return}
        guard let password=passwordField.text   else{return}
        guard let secret=mySecret.text          else{return}
        Auth.auth().createUser(withEmail: username, password: password){user, error in
            if error == nil && user != nil{
                print("User is saved")
                _ = self.navigationController?.popToRootViewController(animated: true)
                //Write here to save data
                saveData()
                
                
            }else{
                print("Error : \(error!.localizedDescription)")
            }
            
        }
        
        func saveData(){
            //first get uid
            guard let uid=Auth.auth().currentUser?.uid else{return}
            //save user info as path
            self.ref.child("Users/\(uid)/secret").setValue(secret)
            
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
