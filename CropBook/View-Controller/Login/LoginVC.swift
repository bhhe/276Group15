//
//  LoginVC.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-16.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase


class LoginVC: UIViewController {
    
    let ref=Database.database().reference()
    
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        guard let username=usernameField.text   else{return}
        guard let password=passwordField.text   else{return}
        
        Auth.auth().signIn(withEmail: username, password: password){user, error in
            if error == nil && user != nil{
                _ = self.navigationController?.popToRootViewController(animated: true)
                
            }else{
                print("Error : \(error!.localizedDescription)")
            }
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
