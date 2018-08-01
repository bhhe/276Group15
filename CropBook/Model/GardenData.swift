//
//  GardenData.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-17.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import Foundation

class GardenData{
    var gardenId : String
    var gardenName : String
    var city : String
    
    init(){
        self.gardenId = ""
        self.gardenName = ""
        self.city = ""
    }
    
    init(gardenId : String, gardenName : String){
        self.gardenId = gardenId
        self.gardenName = gardenName
        self.city = ""
    }
    
    func setId(gardenId : String){
        self.gardenId = gardenId
    }
    
    func setName(gardenName : String){
        self.gardenName = gardenName
    }
    
    func getId() -> String{
        return self.gardenId
    }
    
    
    func getName() -> String{
        return self.gardenName
    }
}
