//
//  GardenData.swift
//  CropBook
//
//  Created by Bowen He on 2018-07-15.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import Foundation

class PostData{
    var postId : String
    var postTitle : String
    var gardenId : String
    var city : String?
    
    init(){
        self.postId = ""
        self.postTitle = ""
        self.gardenId = ""
    }
    init(postId  : String, postTitle : String, gardenId : String){
        self.postId = postId
        self.postTitle = postTitle
        self.gardenId = gardenId
    }
    
    func getGdnId() -> String{
        return self.gardenId
    }
    
    func getGardenId() -> String{
        return self.postId
    }
    
    func getTitle() -> String{
        return self.postTitle
    }
    
    func setGardenId(gardenId : String){
        self.gardenId = gardenId
    }
}
