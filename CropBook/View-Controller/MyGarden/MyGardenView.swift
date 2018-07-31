//
//  MyGardenView.swift
//  CropBook
//
//  Created by jon on 2018-07-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import CoreData

class MyGardenView: UIViewController, UITextFieldDelegate {
    
    weak var delegate: gardenButtonClicked?
    @IBOutlet weak var editName: UIButton!
    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameField.delegate = self
        self.nameField.isUserInteractionEnabled = false
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MyGardenView.viewTapped(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction internal func openCrops(_ sender: Any){
        delegate?.openCrops()
    }
    
    @IBAction internal func postGarden(_ sender: Any){
        if !MY_GARDEN.getOnlineState(){
            delegate?.postGarden()
        } else {
            let alert = UIAlertController(title: "Garden Already posted", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated:true, completion:nil)
                
            }))
            self.present(alert, animated:true, completion:nil)
        }
    }
    
    @IBAction internal func editName(_ sender: Any){
        self.nameField.isUserInteractionEnabled = true
        self.nameField.becomeFirstResponder()
        self.nameField.selectedTextRange = nameField.textRange(from: nameField.beginningOfDocument, to: nameField.endOfDocument)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        self.nameField.isUserInteractionEnabled = false
        MY_GARDEN.setGardenName(name: self.nameField.text!)
        self.nameField.resignFirstResponder()
    }
    
    @IBAction internal func clearCrops(_ sender: Any){
        // Create Alert Message
        let alert = UIAlertController(title: "Clear Crops?", message: "All crops and settings will be removed and cannot be recovered.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            MY_GARDEN.cropProfile.removeAll()
            self.clearCore()
            
            let confirmation = UIAlertController(title: "Crops Removed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            confirmation.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                confirmation.dismiss(animated:true, completion:nil)
            }))
            self.present(confirmation, animated:true, completion:nil)

        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
        }))
        self.present(alert, animated:true, completion:nil)
        
    }
    
    func clearCore(){
        do{
            let fetchRequest: NSFetchRequest<CropProfileCore> = CropProfileCore.fetchRequest()
            let results = try PersistenceService.context.fetch(fetchRequest)
            for managedObject in results{
                print(managedObject.cropName as! String)
                let managedObjectData : NSManagedObject = managedObject as NSManagedObject
                PersistenceService.context.delete(managedObjectData)
            }
            PersistenceService.saveContext()
        }catch{
        }
    }

}
