//
//  Date+ZhihuDaily.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/15.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation

extension Date {
    func timestamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }

    static func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return formatter.date(from: string)!
    }

    func yesterdayString() -> String {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        return formatter.string(from: calendar.date(byAdding: .day, value: -1, to: self)!)
    }

    func dateInfo() -> (String?, String?, String?) {
        guard let calendar = NSCalendar(calendarIdentifier: .gregorian) else {
			return (nil, nil, nil)
        }
        let components = calendar.components([.weekday, .day, .month], from: self)
        guard let weekday = components.weekday,
            let month = components.month,
            let day = components.day else {
            return (nil, nil, nil)
        }

        var weekdayStr: String? = nil
        switch weekday {
        case 1:
            weekdayStr = "日"
        case 2:
            weekdayStr = "一"
        case 3:
            weekdayStr = "二"
        case 4:
            weekdayStr = "三"
        case 5:
            weekdayStr = "四"
        case 6:
            weekdayStr = "五"
        case 7:
            weekdayStr = "六"
        default: break
        }

        let monthStr = month < 10 ? "0" + String(month) : String(month)
        return (monthStr, String(day), weekdayStr)
    }
}
