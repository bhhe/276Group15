//
//  File.swift
//  CropBook
//
//  Created by Jason Wu on 2018-06-28.
//  Copyright © 2018 Jason Wu. All rights reserved.
//

import Foundation

class MyGarden{
    
    var gardenID:String?
    var cropProfile:[CropProfile?]
    var gardenName:String
    var owner:Int?
    var gardenUserID:String?
    var address:String?	
    var dailyCompletion:Bool?
    var isOnline:Bool?
    init(Name name:String,Address address:String) {
        self.cropProfile = [CropProfile?]()
        self.gardenName=name
        self.address=address
        self.isOnline = false
    }
    
    init(Name name:String,Address address:String,GardenID id:String) {
        self.cropProfile = [CropProfile?]()
        self.gardenName=name
        self.address=address
        self.gardenID=id
        self.isOnline = false
    }
    
    func setIsOnline(state: Bool){
        self.isOnline = state;
    }
    
    func getOnlineState()->Bool{
        return self.isOnline!
    }
    
    func AddCrop(New Crop:CropProfile)->Int{       //return position in array
        cropProfile.append(Crop)
        return cropProfile.count-1
    }
    
    func getSize()->Int{
        return cropProfile.count
    }
    
    func RemoveCrop(Position index:Int)->Bool{
        cropProfile.remove(at: index)
        if index>cropProfile.count{
            return false
        }else{
            return true
        }
    }
    
    func editName(Name name:String){
        gardenName=name
    }
    
    func AlertAllMember(){
        
    }
    
    func IsOwner(){
        
    }
}
