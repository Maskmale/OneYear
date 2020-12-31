//
//  Notification.swift
//  OneYear
//
//  Created by Lojii on 2018/11/16.
//  Copyright © 2018 Lojii. All rights reserved.
//

import Foundation
import NotificationCenter
import UserNotifications
import UserNotificationsUI

// 通知管理
class NotificatioManager {
    
    static let share = NotificatioManager()
    
    public func isOpen(_ key: String, completion: @escaping (Bool) -> Void) -> Void {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            print(requests.count)
            if(requests.count <= 0){
                completion(false)
                return
            }
            for req in requests {
                if req.identifier.contains(key) {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
    
    public func removeAllNotifications(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func registNotification(completionHandler: @escaping (Bool,Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert,.sound,.carPlay]) { (success, error) in
            completionHandler(success,error)
        }
    }
    
    func authorizationCheck(completionHandler: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting) in
            if(setting.authorizationStatus == .authorized){
                // 已授权
                completionHandler(true)
            }else if(setting.authorizationStatus == .denied){
                // 无权限
                completionHandler(false)
            }else{
                // 还未授权
                self.registNotification(completionHandler: { (success, error) in
                    if success {
                        completionHandler(success)
                    }else{
                        print(error.debugDescription)
                    }
                })
            }
        }
    }
    
    func openNotification(completionHandler: @escaping (Bool,Error?) -> Void) -> Void {
        authorizationCheck { (success) in
            if(!success){
                completionHandler(false, nil)
                return
            }
            
//            self.addSoloNoti()
//            completionHandler(true,nil)
//            return
            
            //创建当前日历
            let userCalendar = Calendar.current
            let y = OneYear.share.year
            
            let currYear = OneYear(y)
            let currP = (currYear.lastInterval - currYear.firstInterval) / 100 / 1000
            var currTs:[Date] = []
            let currD = currYear.firstDate!
            for i in 0...100 {
                let d = userCalendar.date(byAdding: .second, value: Int(currP) * i, to: currD)
                currTs.append(d!)
            }
            
            let nextYear = OneYear(y+1)
            let nextP = (currYear.lastInterval - currYear.firstInterval) / 100 / 1000
            var nextTs:[Date] = []
            let nextD = nextYear.firstDate!
            for i in 0...100 {
                let d = userCalendar.date(byAdding: .second, value: Int(nextP) * i, to: nextD)
                nextTs.append(d!)
            }
            
            var pushTime:[Dictionary<String, Any>] = []
            
            for i in 0..<currTs.count {
                let t = currTs[i]
                if t <= Date() {
                    continue
                }
                pushTime.append(["index": i,"date":t,"year":y])
            }
            for i in 0..<nextTs.count {
                let t = nextTs[i]
                pushTime.append(["index": i,"date":t,"year":y+1])
            }
            for i in 0..<64 {
                if pushTime.count > i{
                    let time = pushTime[i]
                    self.addNoti(info: time)
                }
            }
            completionHandler(true,nil)
        }
    }
    
    func addNoti(info:[String:Any]) -> Void {
        
        let index = info["index"] as! Int
        let date = info["date"] as! Date
        let year = info["year"] as! Int
        let key = "OneYear-\(year)-\(index)"
        
        let title = NSLocalizedString("Remaining 0", comment: "") + "\(year)" + NSLocalizedString("Remaining 1", comment: "")
        
        let content = UNMutableNotificationContent()
        content.title =  title
        content.body = "\(index)%"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "myNotificationCategory"
        content.userInfo = info
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)
        let request = UNNotificationRequest(identifier: key, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        /*
         ▓▓▓▓▓▓▓▓▓▓▓▓▓░░ 88%
         */
    }
    
    func addSoloNoti(){
        
        
        let title = NSLocalizedString("Remaining 0", comment: "") + "2018" + NSLocalizedString("Remaining 1", comment: "")
        
        let content = UNMutableNotificationContent()
        content.title =  title
        content.body = "99%"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "myNotificationCategory"
        content.userInfo = ["index":99,"date":OneYear.share.firstDate,"year":2018]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: "OneYear", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


