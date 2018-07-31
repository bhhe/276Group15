//
//  GardenListMainVC.swift
//  CropBook
//
//  Created by jon on 2018-07-27.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase
import CoreData

var SHARED_GARDEN_LIST=[MyGarden?]()
var MY_GARDEN: MyGarden = MyGarden(Name: "My Garden", Address: "")
var SIGNED_IN = false

@objc protocol gardenButtonClicked{
    func openCrops()
    func postGarden()
    func openSharedCrops(index: Int)
    func openMap(index: Int)

}

class MyGardenMainVC: UIViewController,gardenButtonClicked{

    @IBOutlet weak var viewContainer : UIView!
    @IBOutlet weak var segControl : UISegmentedControl!
    @IBOutlet weak var signInSignOut : UIButton!
    
    var views: [UIView]!
    var sharedVC : SharedGardenView = SharedGardenView()
    var myGardenVC : MyGardenView = MyGardenView()
    var cropsCore = [CropProfileCore]()
    var gardenIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCoreData()
        
        if let _=Auth.auth().currentUser{
            self.signInSignOut.setTitle("Sign Out", for: UIControlState.normal)
        }
        
        addChildViewController(sharedVC)
        addChildViewController(myGardenVC)
        myGardenVC.delegate = self
        sharedVC.delegate = self
        views = [UIView]()
        views.append(myGardenVC.view)
        views.append(sharedVC.view)
        
        for v in views {
            v.isUserInteractionEnabled = false
            viewContainer.addSubview(v)
        }
        views[0].isUserInteractionEnabled = true
        viewContainer.bringSubview(toFront:  views[0])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCoreData(){
        let fetchRequest: NSFetchRequest<CropProfileCore> = CropProfileCore.fetchRequest()
        do {
            let cropsCore = try PersistenceService.context.fetch(fetchRequest)
            self.cropsCore = cropsCore
        } catch {}
        
        for crop in cropsCore{
            let info = lib.searchByName(cropName: crop.cropName!)
            let profile = CropProfile(cropInfo: info!, profName: crop.profName!)
            MY_GARDEN.AddCrop(New: profile)
        }
    }
    
    // Switch between MyGardenView and SharedGardenView
    @IBAction func switchViewAction(_ sender: UISegmentedControl){
        if let _=Auth.auth().currentUser{
            for i in 0...(views.count-1){
                self.views[i].isUserInteractionEnabled = (i == sender.selectedSegmentIndex)
            }
            self.viewContainer.bringSubview(toFront: views[sender.selectedSegmentIndex])
        } else {
            if sender.selectedSegmentIndex == 1{
                self.SignIn()
            }
        }

    }
    
    //Write Garden into Firebase
    func postGarden() {
        //Assign Garden inside array with ID
        
        print("Posting")
        MY_GARDEN.setIsOnline(state: true)
        //Assign Attribute into garden
        let ref=Database.database().reference()

        let garden = MY_GARDEN.gardenName
        let address = MY_GARDEN.address
        let gardenID = ref.child("Gardens").childByAutoId().key
        MY_GARDEN.gardenID=gardenID
        
        ref.child("Gardens/\(gardenID)/gardenName").setValue(garden)
        //self.ref.child("Gardens/\(gardenID)/Crops").setValue()
        ref.child("Gardens/\(gardenID)/Address").setValue(address)
        
        //Save gardenID into the user profile
        guard let userid=Auth.auth().currentUser?.uid else {return}
        let gardenRef=ref.child("Users/\(userid)/Gardens").child(gardenID)
        print(gardenID)
        gardenRef.setValue(true)
        
        
        print("Adding Crops")
        for i in 0..<MY_GARDEN.getSize(){
            //let gardenID=GardenList[gardenIndex]?.gardenID
            let cropname = MY_GARDEN.cropProfile[i]?.GetCropName()
            let profName = MY_GARDEN.cropProfile[i]?.profName
            let cropRef=ref.child("Gardens/\(gardenID)/CropList").childByAutoId()
            cropRef.child("CropName").setValue(cropname)
            cropRef.child("ProfName").setValue(profName)
            print("Crop added")
        }
        self.sharedVC.GetOnlineGardens()
    }
    
    @IBAction internal func SignInSelected(_ sender: Any){
        if let _=Auth.auth().currentUser{
            try! Auth.auth().signOut()
            self.signInSignOut.setTitle("Sign In", for: UIControlState.normal)
        } else {
            self.SignIn()
        }
    }
    
    func SignIn(){
        let alertController = UIAlertController(title: nil, message: "Login/Signup", preferredStyle: .alert)
        
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
                alertController.dismiss(animated: true, completion: nil)
                let alert = UIAlertController(title: "Passwords do not match", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                    alert.dismiss(animated:true, completion:nil)
                }))
                self.present(alert, animated:true, completion:nil)
            }
            
            //Login With Firebase
            Auth.auth().signIn(withEmail: username, password: password){user, error in
                if error == nil && user != nil{
                    // signInSuccess
                    self.signInSignOut.setTitle("Sign Out", for: UIControlState.normal)
                } else {
                    print("Error : \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Inavlid Username/Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
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
                alertController.dismiss(animated: true, completion: nil)
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
                    self.signInSignOut.setTitle("Sign Out", for: UIControlState.normal)
                } else {
                    print("Error : \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Inavlid Username/Password", message: "Password must be at least 6 Characters", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        alert.dismiss(animated:true, completion:nil)
                    }))
                    self.present(alert, animated:true, completion:nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (_) in
            self.segControl.selectedSegmentIndex = 0
        }
        alertController.addAction(loginAction)
        alertController.addAction(signupAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func openSharedCrops(index: Int){
        self.gardenIndex = index
        performSegue(withIdentifier: "showSharedCrops", sender: self)
    }
    
    func openCrops(){
        performSegue(withIdentifier: "showCrops", sender: self)
    }
    
    func openMap(index: Int) {
        self.gardenIndex = index
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "showCrops")  {
            let nextController=segue.destination as!GardenCropList
            nextController.Online=false
        }
        else if (segue.identifier == "showSharedCrops") {
            let nextController=segue.destination as!GardenCropList
            nextController.gardenIndex = gardenIndex!
            nextController.Online=true
        } else if (segue.identifier == "showMap") {
            let nextController=segue.destination as!MapVC
            nextController.gardenIndex = gardenIndex!
        }
    }
    

}
