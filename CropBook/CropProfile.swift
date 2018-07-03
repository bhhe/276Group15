//: Playground - noun: a place where people can play

import UIKit


class CropProfile
{
//varaibles for crop attributes
    var cropid: Int
    var cropName: String
    var cropType: String
    var wateringVariable: Float
    
    
//object seperation step

    init (cropid: Int,cropName: String, cropType: String, wateringVariable: Float)
    {
        self.cropid = cropid
        self.cropName = cropName
        self.cropType = cropType
        self.wateringVariable = wateringVariable
        
    }
    

    //funtion to get attributes of different objects
    func GetCropid()-> Int
    {
        return self.cropid
    }
    
    func GetCropName()-> String
    {
        return self.cropName
    }
    
    func GetCropType()-> String
    {
        return self.cropType
    }
    
    func GetWateringVariable()-> Float
    {
        return self.wateringVariable
    }
    
}



