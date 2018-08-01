//
//  SearchViewController.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-02.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    var cropIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func searchLib(_ sender: Any) {
        if lib.searchByName(cropName: searchBar?.text ?? "") != nil{
            cropIndex = lib.getCropIndex(cropName : searchBar?.text ?? "")!
            performSegue(withIdentifier: "searched", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let receiverVC = segue.destination as! CInfoViewController
        receiverVC.cropFound = lib.getMainLibrary()[cropIndex]
    }

}
