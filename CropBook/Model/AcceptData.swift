//
//  AcceptData.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-18.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import Foundation

class AcceptData{
    var uId : String
    var gardenId : String
    var name : String
    var info : String
    
    init(){
        uId = ""
        gardenId = ""
        name = ""
        info = ""
    }
    
    init(uId : String, gardenId : String, name : String, info : String){
        self.uId = uId
        self.gardenId = gardenId
        self.name = name
        self.info = info
    }
    
    func setPostId(uId : String){
        self.uId = uId
    }
    
    func setGardenId(gId : String){
        self.gardenId = gId
    }
    
    func setName(name : String){
        self.name = name
    }
    
    func setInfo(info : String){
        self.info = info
    }
}
