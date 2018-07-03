//
//  SearchViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    var cropIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchLabel.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchLib(_ sender: Any) {
        if lib.searchByName(cropName: searchBar?.text ?? "") != nil{
            cropIndex = lib.getCropIndex(cropName : searchBar?.text ?? "")!
            performSegue(withIdentifier: "searched", sender: self)
        }else{
            searchLabel.text = "Sorry, that crop is not of this planet"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! CInfoViewController
        receiverVC.cropFound = lib.getMainLibrary()[cropIndex]
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
