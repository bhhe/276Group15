//
//  CropInfo.swift
//  TestLibrary
//
//  Created by Bowen He on 2018-06-30.
//  Copyright © 2018 Bowen He. All rights reserved.
//

import Foundation

class CropInfo{
    
    let cropName : String;
    let coEff : Coefficients;
    let cropType : String;
    let image : String;
    let sunExposure : String;
    let soilType : String;
    let soilpH : String;
    
    init(){
        self.cropName = ""
        self.coEff = Coefficients(initial: 0, mid: 0, end: 0)
        self.cropType = ""
        self.image = ""
        self.sunExposure = ""
        self.soilType = ""
        self.soilpH = ""
    }
    
    init(json:[String: Any],coEff:Coefficients) {
        self.cropName = json["cropName"] as? String ?? ""
        self.coEff = coEff
        self.cropType = json["Type"] as? String ?? ""
        self.image = json["Image"] as? String ?? ""
        self.sunExposure = json["sunExposure"] as? String ?? ""
        self.soilType = json["soilType"] as? String ?? ""
        self.soilpH = json["soilpH"] as? String ?? ""
    }
    
    func getName() -> String{
        return cropName
    }
    
    func getType() -> String{
        return cropType
    }
    
    func getCoEff() -> Coefficients{
        return coEff
    }
    
    func isSameCrop(matchCrop: String) -> Bool{
        return cropName.lowercased() == matchCrop.lowercased()
    }
    
    func isSameType(matchType: String) -> Bool{
        return cropType.lowercased() == matchType.lowercased()
    }
    
    func printData(){
        print(cropName + "\n" + cropType)
        coEff.printData()
        print(image + "\n" + sunExposure)
        print(soilType + "\n" + soilpH)
        print()
    }
}
