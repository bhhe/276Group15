//
//  Weather.swift
//  CropBook
//
//  Created by jon on 2018-07-01.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import AerisWeatherKit

class Weather: NSObject {
    
    var tempC : Float = 0; //temperature in Celcius
    var daylightPercentage : Float = 0.7;
    var waterReq : Float = -1;

    func GetTempC() -> Float {
        return self.tempC
    }
    
    func GetWaterRequirements() -> Float{
        return self.waterReq
    }
    
    func UpdateWaterRequirements(coEfficient: Float) {
        self.CheckWeather(coEfficient:coEfficient)
    }
    
    func CheckWeather(coEfficient: Float) {
        //Obtain current temperature in Celcius
        print("Calculating Weather")
        let place = AWFPlace(city: "burnaby", state: "bc", country: "ca")
        AWFObservations.sharedService().get(forPlace: place, options: nil){ (result) in
            guard let results = result?.results else { print("Data failed to load - \(String(describing: result?.error))"); return }
            guard let obs = results.first as? AWFObservation else { return }
            self.tempC = Float(obs.tempC)
            print("The current weather in \(String(describing: place.name)) is \(String(describing: obs.weather)) with a temperature of \(obs.tempC).")
            self.CheckSunMoon(coEfficient:coEfficient)
        }
    }
    
    func CheckSunMoon(coEfficient: Float) {
        print("Calculated")
        //Determines the time of the sunrise and sunset
        print("Checking SunMoon")
        let place = AWFPlace(city: "burnaby", state: "bc", country: "ca")
        AWFSunMoon.sharedService().get(forPlace: place, options: nil){ (result) in
            guard let results = result?.results else { print("Data failed to load - \(String(describing: result?.error))"); return }
            guard let obs = results.first as? AWFSunMoonPeriod else { return }
            let sunrise : Date = obs.sunrise!
            let sunset : Date = obs.sunset!
            //Calculates percentage of the day that has daylight
            self.daylightPercentage = Float(sunset.timeIntervalSince(sunrise)/86400)
            print(self.daylightPercentage)
            self.CalculateWaterRequirements(coEfficient:coEfficient)
        }
    }
    
    func CalculateWaterRequirements(coEfficient: Float){
        print("Calculating Water Requirement")
        self.waterReq = coEfficient * (self.daylightPercentage * (0.46 * self.tempC+8))
        print(self.waterReq)
    }
    
}
