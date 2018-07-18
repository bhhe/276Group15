//
//  Posting.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-15.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Posting{
    var postTitle : String
    var postRef : DatabaseReference
    var description : String
    var gardenRef : String
    var harvest : String
    var crops : [String]
    
    //var postDescription : String
    
    /*
    init(postTitle : String, postDescription : String){
        self.postTitle = postTitle
        self.postDescription = postDescription
    }
    */
    init(){
        self.postTitle = ""
        self.postRef = Database.database().reference()
        self.description = ""
        self.gardenRef = ""
        self.harvest = ""
        self.crops = [String]()
    }
    
    func setTitle(title : String){
        self.postTitle = title
    }
    
    func setPostRef(postRef : DatabaseReference){
        self.postRef = postRef
    }
    
    func setDescription(description : String){
        self.description = description
    }
    
    func setGardenRef(gardenRef : String){
        self.gardenRef = gardenRef
    }
    
    func setHarvest(harvest : String) {
        self.harvest = harvest
    }
    
    func setCrops(cropNames : [String]){
        self.crops = cropNames
    }
    func getTitle() -> String{
        return self.postTitle
    }
    
    func getRef() -> DatabaseReference{
        return self.postRef
    }
    
    func getDescription() -> String{
        return self.description
    }
    
    func getGardRef() -> String{
        return self.gardenRef
    }
    
    func getHarvest() -> String{
        return self.harvest
    }
    
    func getCrops() -> [String] {
        return self.crops
    }
    /*
    func getDescription() -> String{
        return self.postDescription
    }
    */
    
}
