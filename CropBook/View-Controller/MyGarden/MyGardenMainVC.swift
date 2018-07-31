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
    func postGardenPrompt()
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
    let fetchRequest: NSFetchRequest<CropProfileCore> = CropProfileCore.fetchRequest()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        if let _=Auth.auth().currentUser{
            self.signInSignOut.setTitle("Sign Out", for: UIControlState.normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadCoreData(){
        do {
            let cropsCore = try PersistenceService.context.fetch(fetchRequest)
            self.cropsCore = cropsCore
        } catch {}
        
        for crop in cropsCore{
            let info = lib.searchByName(cropName: crop.cropName!)
            let profile = CropProfile(cropInfo: info!, profName: crop.profName!)
            profile.coreData = crop
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
    
    func postGardenPrompt() {
        
        // Make sure user is logged in
        if let _=Auth.auth().currentUser{
            let alertController = UIAlertController(title: "Post Garden?", message: "Garden can be seen by others", preferredStyle: .alert)
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Address (Optional)"
            }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "City"
            }
            
            alertController.addTextField { (textField) in
                textField.placeholder = "Postal Code"
            }
            
            let shareAction = UIAlertAction(title: "Post", style: .default) { (_) in
                
                let addressField = alertController.textFields![0]
                let cityField = alertController.textFields![1]
                let postalField = alertController.textFields![2]
                
                let address = addressField.text
                let city = cityField.text
                let postalCode = postalField.text
                
                
                if city != "" && postalCode != "" {
                    MY_GARDEN.setAddress(address: address!, city: city!, postalCode: postalCode!)
                    self.postGarden()
                } else {
                    alertController.dismiss(animated: true, completion: nil)
                    let alert = UIAlertController(title: "Missing Entries", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        alert.dismiss(animated:true, completion:nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alertController.addAction(shareAction)
            alertController.addAction(cancelAction)
            
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        } else {
            self.SignIn()
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
        
        //create another attribute members so we know who's participating
        
        let memberRef=ref.child("Gardens/\(gardenID)/members/\(userid)")
        let userEmail = Auth.auth().currentUser?.email
        memberRef.setValue(userEmail)
        let ownerRef = ref.child("Gardens/\(gardenID)/Owner")
        ownerRef.setValue(userEmail)
        
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
    
    func forceOfflineView(){
        for i in 0...(views.count-1){
            self.views[i].isUserInteractionEnabled = (i == 0)
        }
        self.viewContainer.bringSubview(toFront: views[0])
    }
    
    @IBAction internal func SignInSelected(_ sender: Any){
        if let _=Auth.auth().currentUser{
            try! Auth.auth().signOut()
            self.forceOfflineView()
            self.segControl.selectedSegmentIndex = 0

            self.signInSignOut.setTitle("Sign In", for: UIControlState.normal)
        } else {
            self.SignIn()
        }
    }
    
    func SignIn(){
        let alertController = UIAlertController(title: nil, message: "Login", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
            textField.keyboardType = .emailAddress
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        }
        
        let loginAction = UIAlertAction(title: "Login", style: .default) { (_) in
            let emailField = alertController.textFields![0]
            let passwordField = alertController.textFields![1]

            //Perform validation or whatever you do want with the text of textfield
            guard let username = emailField.text   else{return}
            guard let password = passwordField.text   else{return}
            
            //Login With Firebase
            Auth.auth().signIn(withEmail: username, password: password){user, error in
                if error == nil && user != nil{
                    // signInSuccess
                    self.sharedVC.GetOnlineGardens()
                    self.segControl.selectedSegmentIndex = 0

                    self.signInSignOut.setTitle("Sign Out", for: UIControlState.normal)
                } else {
                    print("Error : \(error!.localizedDescription)")
                    self.forceOfflineView()
                    self.segControl.selectedSegmentIndex = 0
                    let alert = UIAlertController(title: "Inavlid Username/Password", message: "", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        alert.dismiss(animated:true, completion:nil)
                    }))
                    
                    self.present(alert, animated:true, completion:nil)
                }
            }
        }
        
        let signupAction = UIAlertAction(title: "Signup", style: .default) { (_) in
            alertController.dismiss(animated: true, completion: nil)
            self.signup()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (_) in
            self.forceOfflineView()
            self.segControl.selectedSegmentIndex = 0
        }
        alertController.addAction(loginAction)
        alertController.addAction(signupAction)
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func signup(){
        let alertController = UIAlertController(title: nil, message: "Signup", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
            textField.keyboardType = .emailAddress
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Confirm Password"
            textField.isSecureTextEntry = true
            textField.addConstraint(textField.heightAnchor.constraint(equalToConstant: 30))
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
                self.forceOfflineView()
                self.segControl.selectedSegmentIndex = 0
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
                    self.forceOfflineView()
                    self.segControl.selectedSegmentIndex = 0
                    print("Error : \(error!.localizedDescription)")
                    let alert = UIAlertController(title: "Inavlid Username/Password", message: "Password must be at least 6 Characters. Email must be valid.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                        alert.dismiss(animated:true, completion:nil)
                    }))
                    self.present(alert, animated:true, completion:nil)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ (_) in
            self.forceOfflineView()
            self.segControl.selectedSegmentIndex = 0
        }
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
