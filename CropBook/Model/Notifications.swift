//
//  Notifications.swift
//  CropBook
//
//  Created by jon on 2018-06-30.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import UserNotifications

class Notifications: NSObject {
    
    var hour : Int = 0;
    var minute : Int = 0;
    var timeString : String = "1:00 PM"
    // Weekdays are Sunday=1 ... Saturday=7
    var weekDay : Int = 1;
    var scheduleDays : [Int] = []
    var enabled : Bool = false;
    var second : Int = 0;
    var notificationID = [String](repeating: "", count: 7)
    
    func setHour(Hour : Int) {
        self.hour = Hour
    }
    
    func setMinute(Minute : Int) {
        self.minute = Minute
    }
    
    func setTimeOfDay(Hour: Int, Minute: Int){
        self.minute = Minute
        self.hour = Hour
    }
    
    func setWeekDay(Day:Int){
        self.weekDay = Day
    }
    func setSeconds(Second : Int){
        self.second = Second
    }
    func setScheduleDays(days: [Int]){
        self.scheduleDays = days
    }
    func setTimeString(time: String) {
        self.timeString = time
    }
    
    func getTimeString()-> String{
        return self.timeString
    }
    
    func Schedule(msg : String) {
        //iOS 10 or above
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        
        content.title = "Watering Time!"
        content.body = msg
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        // Set specific time and data here
        var dateComponents = DateComponents()
        dateComponents.hour = self.hour
        dateComponents.minute = self.minute
        dateComponents.weekday = self.weekDay
        // Initialise trigger for specfic time and date
        //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // Sets trigger for 5 seconds to test
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // Make Request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        // Schedule Request
        center.add(request)
    }
    
    func scheduleEachWeekday(msg : String){
        
        if self.enabled == true {
            self.disableNotifications()
            for i in self.scheduleDays{
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                
                content.title = "Watering Time!"
                content.body = msg
                content.categoryIdentifier = "alarm"
                content.sound = UNNotificationSound.default()
                
                // Set specific time and data here
                var dateComponents = DateComponents()
                dateComponents.hour = self.hour
                dateComponents.minute = self.minute
                dateComponents.weekday = i+1
                // Initialise trigger for specfic time and date
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                // Generate unique ID for notifications
                self.notificationID[i] = UUID().uuidString
                print(self.hour, self.minute)
                print("Making notification request: ", i, ", UUID: ", self.notificationID)
                // Make Request
                let request = UNNotificationRequest(identifier: self.notificationID[i], content: content, trigger: trigger)
                // Schedule Request
                center.add(request)
            }
        }
    }
    
    func disableNotifications(){
        //self.enabled = false
        //UIApplication.shared.cancelAllLocalNotifications()
        let notifications = UNUserNotificationCenter.current()
        //notifications.removeAllPendingNotificationRequests()
        print("Removing notifications UUID: ", self.notificationID)
        notifications.removePendingNotificationRequests(withIdentifiers: self.notificationID)
        //self.notificationID = UUID().uuidString
    }
    
    func RequestPermission(){
        print("Verifying Notification Permission")
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound];
        center.requestAuthorization(options: options) {
            (granted, error) in
        if !granted {
            print("Permission Refused")
            }
        }
    }

}

