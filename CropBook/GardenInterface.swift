//
//  GardenInterface.swift
//  CropBook
//
//  Created by Jason Wu on 2018-07-01.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class GardenInterface: UIViewController {

    @IBOutlet weak var garden1Button: UIButton!
    @IBOutlet weak var delete2: UIButton!
    @IBOutlet weak var delete1: UIButton!
    @IBOutlet weak var garden2Button: UIButton!
    @IBOutlet weak var delete3: UIButton!
    @IBOutlet weak var garden3Button: UIButton!
    
    @IBOutlet weak var emptyGardenLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if GardenList.count>0{
            if let garden1=GardenList[0]?.gardenName{
                garden1Button.isHidden=false
                emptyGardenLabel.isHidden=true
                garden1Button.setTitle(garden1,for: .normal)
                delete1.isHidden=false
            }else{
                print("Garden1 is empty")
            }
        }
        
        if GardenList.count>1{
            if let garden2=GardenList[1]?.gardenName{
                garden2Button.isHidden=false
                garden2Button.setTitle(garden2,for: .normal)
                delete2.isHidden=false
            }else{
                print("Garden2 is empty")
            }
        }
        
        if GardenList.count>2{
            if let garden3=GardenList[2]?.gardenName{
                garden3Button.isHidden=false
                garden3Button.setTitle(garden3,for: .normal)
                delete3.isHidden=false
            }else{
                print("Garden3 is empty")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func Delete1(_ sender: Any) {
        garden1Button.isHidden=true
        delete1.isHidden=true
        GardenList.removeFirst()
        
    }
    
    
    @IBAction func Delete2(_ sender: Any) {
        garden2Button.isHidden=true
        delete2.isHidden=true
        if garden1Button.isHidden==true{
            GardenList.removeFirst()
        }else{
            GardenList.remove(at: 1)
        }
    }
    
    
    
    @IBAction func Delete3(_ sender: Any) {
        garden3Button.isHidden=true
        delete3.isHidden=true
        GardenList.removeLast()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
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
