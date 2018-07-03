//
//  CropLibrary.swift
//  TestLibrary
//
//  Created by Bowen He on 2018-06-30.
//  Copyright © 2018 Bowen He. All rights reserved.
//

import Foundation

class CropLibrary{
    var cropDatabase: [CropInfo]
    var fruitDatabase: [CropInfo]
    var veggieDatabase: [CropInfo]
    
    init(jsonName : String){
        cropDatabase = [CropInfo]()
        fruitDatabase = [CropInfo]()
        veggieDatabase = [CropInfo]()
        loadJsonInto(fileName: jsonName)
    }
    
    func getTotalSize() -> Int{
        return cropDatabase.count
    }
    
    func getMainLibrary() -> [CropInfo]{
        return cropDatabase
    }
    
    func getFruitLibrary() -> [CropInfo]{
        return fruitDatabase
    }
    
    func getVeggieLibrary() -> [CropInfo]{
        return veggieDatabase
    }
    
    func getCropIndex(cropName : String) -> Int!{
        let loweredName = cropName.lowercased()
        return cropDatabase.index(where : {$0.getName().lowercased() == loweredName})
    }
    func addToLibrary(newCropData : CropInfo){
        cropDatabase.append(newCropData)
        addCrctCategory(cropInfo: newCropData)
    }
    
    func searchByName(cropName : String) -> CropInfo?{
        for crop in cropDatabase{
            if crop.isSameCrop(matchCrop: cropName){
                return crop
            }
        }
        return nil
    }
    
    func loadJsonInto(fileName:String){
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            guard let array = json as?[Any] else{ return }
            
            for crop in array {
                guard let cropInfos = crop as?[String:Any] else { return }
                guard let cocoEfficients = cropInfos["coEfficients"] as?[String:Double] else { return }
                let coEffs = Coefficients(json: cocoEfficients)
                let cropInfo = CropInfo(json: cropInfos,coEff: coEffs)
                addToLibrary(newCropData: cropInfo)
            }
            
        }catch{
            print(error)
        }
        sortLibraries()
    }
    
    func sortLibraries(){
        cropDatabase.sort(by: {$0.getName() < $1.getName()})
        veggieDatabase.sort(by: {$0.getName() < $1.getName()})
        fruitDatabase.sort(by: {$0.getName() < $1.getName()})
    }
    
    func addCrctCategory(cropInfo: CropInfo){
        if cropInfo.isSameType(matchType: "fruit"){
            fruitDatabase.append(cropInfo)
        }else if(cropInfo.isSameType(matchType: "vegetable")){
            veggieDatabase.append(cropInfo)
        }
    }
    
    func searchByCategory(categoryType : String) -> [CropInfo]?{
        if (categoryType.lowercased() == "fruit"){
            return fruitDatabase
        }else if (categoryType.lowercased() == "vegetable"){
            return veggieDatabase
        }
        return nil
    }
    
    func printByCategory(category: String){
        
        if (category.lowercased() == "fruit"){
            print("Fruit Database:")
            for crop in fruitDatabase{
                crop.printData()
            }
        }else if (category.lowercased() == "vegetable"){
            print("Vegetable Database:")
            for crop in veggieDatabase{
                crop.printData()
            }
        }
        print("------------------")
    }

    func printAllCrops(){
        for crop in cropDatabase{
            crop.printData()
        }
    }
    
}
