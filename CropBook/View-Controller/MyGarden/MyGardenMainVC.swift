//
//  GardenListMainVC.swift
//  CropBook
//
//  Created by jon on 2018-07-27.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import Firebase
var SHARED_GARDEN_LIST=[MyGarden?]()
var MY_GARDEN: MyGarden = MyGarden(Name: "My Garden", Address: "")

@objc protocol gardenButtonClicked{
    func openCrops()
    func postGarden()
    func openSharedCrops(index: Int)
    func openMap(index: Int)

}

class MyGardenMainVC: UIViewController,gardenButtonClicked{

    @IBOutlet weak var viewContainer : UIView!
    var views: [UIView]!
    var sharedVC : SharedGardenView = SharedGardenView()
    var myGardenVC : MyGardenView = MyGardenView()
    var gardenIndex : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    // Switch between MyGardenView and SharedGardenView
    @IBAction func switchViewAction(_ sender: UISegmentedControl){
        for i in 0...(views.count-1){
            self.views[i].isUserInteractionEnabled = (i == sender.selectedSegmentIndex)
        }
        self.viewContainer.bringSubview(toFront: views[sender.selectedSegmentIndex])
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
            //nextController.gardenIndex = gardenIndex!
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
