//
//  CtgyViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class CtgyViewController: UIViewController {

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var wheatButton: UIButton!
    @IBOutlet weak var veggieButton: UIButton!
    @IBOutlet weak var fruitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectCategory(sender : UIButton!){
        if sender == fruitButton{
            ctgyLib = lib.getFruitLibrary()
        }else if sender == veggieButton{
            ctgyLib = lib.getVeggieLibrary()
        }else if sender == wheatButton{
            ctgyLib = [CropInfo]()    
        }else{
            ctgyLib = lib.getMainLibrary()
        }
        //performSegue(withIdentifier: "sltdCtgySegue", sender: self)
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
