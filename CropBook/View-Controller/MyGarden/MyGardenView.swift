//
//  MyGardenView.swift
//  CropBook
//
//  Created by jon on 2018-07-28.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit



class MyGardenView: UIViewController {
    weak var delegate: gardenButtonClicked?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        }
    }
    
    @IBAction internal func clearCrops(_ sender: Any){
        // Create Alert Message
        let alert = UIAlertController(title: "Clear Crops?", message: "All crops and settings will be removed and cannot be recovered.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated:true, completion:nil)
            MY_GARDEN.cropProfile.removeAll()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
