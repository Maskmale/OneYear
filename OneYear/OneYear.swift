//
//  OneYear.swift
//  OneYear
//
//  Created by Lojii on 2018/11/13.
//  Copyright © 2018 Lojii. All rights reserved.
//

import UIKit

let TimeType = "TimeType"


class OneYear  {
    
    static let share = OneYear(nil)
    
    public var timeType = 0
    
    public var year:Int = 2018
    var secondCount = 1
    
    var firstDate:Date!
    var firstInterval:TimeInterval!
    var firstCom:DateComponents!
    
    var lastDate:Date!
    var lastInterval:TimeInterval!
    var lastCom:DateComponents!
    
    
    var oneYear:TimeInterval!
    
    init(_ y: Int?) {
        initDateParam(y)
    }
    
    // 一年里总的毫秒数
    func initDateParam(_ y: Int?) -> Void {
        
        let calendar = NSCalendar.current
        
        if y != nil {
            year = y!
        }else{
            let currentDate = calendar.dateComponents([.year,.month,.day], from: Date())
            year = currentDate.year ?? 2018
        }
        
        var com1 = DateComponents()
        com1.year = year
        com1.month = 12
        com1.day = 31
        com1.hour = 23
        com1.minute = 59
        com1.second = 59
        com1.nanosecond = 999999999
//        com1.calendar = calendar
//        com1.timeZone = NSTimeZone.local
        lastDate = calendar.date(from: com1)
        lastInterval = lastDate.timeIntervalSince1970*1000
        lastCom = com1
        
        var com2 = DateComponents()
        com2.year = year
        com2.month = 1
        com2.day = 1
        com2.hour = 0
        com2.minute = 0
        com2.second = 0
        com2.nanosecond = 1
//        com2.calendar = calendar
//        com2.timeZone = NSTimeZone.local
        firstDate = calendar.date(from: com2)
        firstInterval = firstDate.timeIntervalSince1970*1000
        firstCom = com2
        
        oneYear = lastInterval-firstInterval
        
        let ud = UserDefaults()
        timeType = ud.integer(forKey: TimeType)
        
    }
    
    public func currentProgress() -> String{
        
        let per = currentProgressValue()
        if timeType == 0 {
            return String(format:"%.7f",per) + " %"
        }else{
            return String(format:"%.2f",per) + " %"
        }
    }
    
    public func currentProgressValue() -> Double{
        
        let nowInterval = Date().timeIntervalSince1970*1000
        if nowInterval > lastInterval {
            initDateParam(nil)
            return 100
        }
        let interval = nowInterval - firstInterval
        let per = interval / oneYear * 100
        return per
    }
    
    public func switchType() -> Void {
        let ud = UserDefaults()
        let old = ud.integer(forKey: TimeType)
        if old == 0 {
            ud.set(1, forKey: TimeType)
        }else{
            ud.set(0, forKey: TimeType)
        }
        initDateParam(nil)
    }
    
}
