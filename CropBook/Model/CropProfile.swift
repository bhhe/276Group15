
import UIKit


class CropProfile{
    
    //varaibles for crop attributes
    var cropID : String?
    var cropName : String
    var profName : String
    var cropType : String
    var wateringVariable : Coefficients
    var plantCare : String
    var plantFeeding : String
    var plantSpacing : String
    var plantNotes : String
    var plantHarvesting : String
    var image : String
    var notif: Notifications
    var coreData : CropProfileCore?
    var surfaceArea:Double?
    
    init (){
        self.cropName = ""
        self.profName = ""
        self.cropType = ""
        self.wateringVariable = Coefficients(initial: 0, mid: 0, end: 0)
        self.plantCare = ""
        self.plantFeeding = ""
        self.plantSpacing = ""
        self.plantNotes = ""
        self.plantHarvesting = ""
        self.image = ""
        self.notif = Notifications()
    }
    
    init (cropInfo : CropInfo, profName : String){
        self.cropName = cropInfo.getName()
        self.profName = cropName
        self.cropType = cropInfo.getType()
        self.wateringVariable = cropInfo.getCoEff()
        self.plantCare = cropInfo.getCare()
        self.plantFeeding = cropInfo.getFeeding()
        self.plantSpacing = cropInfo.getSpacing()
        self.plantNotes = cropInfo.getNotes()
        self.plantHarvesting = cropInfo.getHarvesting()
        self.image = cropInfo.getImage()
        self.notif = Notifications()
    }
    
    /*************
        Getters()
     *************/
    func GetCropName()-> String
    {
        return self.cropName
    }
    
    func GetCropType()-> String
    {
        return self.cropType
    }
    
    func getImage() -> String{
        return image
    }
    
    func getCare() -> String{
        return self.plantCare
    }
    
    func getFeeding() -> String{
        return self.plantFeeding
    }
    
    func getSpacing() -> String{
        return self.plantSpacing
    }
    
    func getNotes() -> String{
        return self.plantNotes
    }
    
    func getHarvesting() -> String{
        return self.plantHarvesting
    }
    
    func GetWateringVariable() -> Coefficients{
        return self.wateringVariable
    }
    
    func setNotification(Hours : Int, msg : String){
        let str = cropName + " : "
        let notifMsg = str + msg
        notif.setHour(Hour: Hours)
        notif.Schedule(msg: notifMsg)
    }
    
    func setSurfaceArea(area: Double){
        self.surfaceArea = area
    }
    
    func printData(){
        print(cropName)
    }
    
    
}



