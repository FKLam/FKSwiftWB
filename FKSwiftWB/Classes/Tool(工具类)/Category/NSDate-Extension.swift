//
//  NSDate-Extension.swift
//  FKSwiftWB
//
//  Created by kun on 16/8/1.
//  Copyright © 2016年 kun. All rights reserved.
//

import Foundation

extension NSDate {
    class func createDateString(createAtStr: String) -> String {
        // 创建时间格式化对象
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        fmt.locale = NSLocale(localeIdentifier: "en")
        
        // 将字符串时间，转换成NSDate类型
        guard let createDate = fmt.dateFromString(createAtStr) else {
            return ""
        }
        
        // 创建当前时间
        let nowDate = NSDate()
        
        // 计算创建时间和当前时间差
        let interval = Int(nowDate.timeIntervalSinceDate(createDate))
        
        // 显示“刚刚”
        if interval < 60 {
            return "刚刚"
        }
        
        // 59分钟前
        if interval < 60 * 60 {
            return "\(interval / 60)分钟前"
        }
        
        // 11小时前
        if interval < 60 * 60 * 24 {
            return "\(interval / (60 * 60))小时前"
        }
        
        // 创建日历对象
        let calendar = NSCalendar.currentCalendar()
        
        // 处理昨天数据：昨天 12:23
        if calendar.isDateInYesterday(createDate) {
            fmt.dateFormat = "昨天 HH:mm"
            let timeStr = fmt.stringFromDate(createDate)
            return timeStr
        }
        
        // 处理一年之内：02-22 12:22
        let cmps = calendar.components(.Year, fromDate: createDate, toDate: nowDate, options: [])
        if cmps.year < 1 {
            fmt.dateFormat = "MM-dd HH:mm"
            let timeStr = fmt.stringFromDate(createDate)
            return timeStr
        }
        
        // 处理超过一年：2014-02-12 13:22
        fmt.dateFormat = "yyyy-MM-dd HH:mm"
        let timeStr = fmt.stringFromDate(createDate)
        return timeStr
    }
}
