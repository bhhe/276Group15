//
//  AcceptData.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-18.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import Foundation

class AcceptData{
    var postId : String
    var gardenId : String
    var name : String
    var info : String
    
    init(){
        postId = ""
        gardenId = ""
        name = ""
        info = ""
    }
    
    func setPostId(pId : String){
        self.postId = pId
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
