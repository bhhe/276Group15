//
//  CheckLoginVC.swift
//  CropBook
//
//  Created by jon on 2018-07-29.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase

class CheckLoginVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let _=Auth.auth().currentUser{
            self.performSegue(withIdentifier: "showPostings", sender: self)
        } else {
            self.signIn()
        }
        
    }

    func signIn(){
        let alertController = UIAlertController(title: nil, message: "CropBook", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password Confirmation"
            textField.isSecureTextEntry = true
        }
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { (_) in
            let emailField = alertController.textFields![0]
            let passwordField = alertController.textFields![1]
            let confirmPasswordField = alertController.textFields![2]
            
            //Perform validation or whatever you do want with the text of textfield
            guard let username = emailField.text   else{return}
            guard let password = passwordField.text   else{return}
            guard let confirmPassword = confirmPasswordField.text   else{return}
            
            if password != confirmPassword {
                //passwords don't match
                let alert = UIAlertController(title: "Passwords do not match", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    alert.dismiss(animated:true, completion:nil)
                }))
                self.present(alert, animated:true, completion:nil)
            }
            
            //Login With Firebase
            Auth.auth().signIn(withEmail: username, password: password){user, error in
                if error == nil && user != nil{
                    // Move into next ViewController
                    self.performSegue(withIdentifier: "showPostings", sender: self)
                } else {
                    print("Error : \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Inavlid Username/Password", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        alert.dismiss(animated:true, completion:nil)
                    }))
                    
                    self.present(alert, animated:true, completion:nil)
                }
            }
            
        }
        
        let signupAction = UIAlertAction(title: "Signup", style: .default) { (_) in
            let emailField = alertController.textFields![0]
            let passwordField = alertController.textFields![1]
            let confirmPasswordField = alertController.textFields![2]
            
            //Perform validation or whatever you do want with the text of textfield
            guard let username = emailField.text   else{return}
            guard let password = passwordField.text   else{return}
            guard let confirmPassword = confirmPasswordField.text   else{return}
            
            if password != confirmPassword {
                //passwords don't match
                let alert = UIAlertController(title: "Passwords do not match", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    alert.dismiss(animated:true, completion:nil)
                }))
                self.present(alert, animated:true, completion:nil)
            }
            
            //Signup With Firebase
            Auth.auth().createUser(withEmail: username, password: password){user, error in
                if error == nil && user != nil{
                    print("User is saved")
                    self.performSegue(withIdentifier: "showPostings", sender: self)
                } else {
                    print("Error : \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Inavlid Username/Password", message: "Password must be at least 6 Characters. Valid emails only.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        alert.dismiss(animated:true, completion:nil)
                    }))
                    self.present(alert, animated:true, completion:nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.tabBarController?.selectedIndex = 0
        }
        
        alertController.addAction(loginAction)
        alertController.addAction(signupAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
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
