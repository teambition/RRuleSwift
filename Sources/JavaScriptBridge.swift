//
//  JavaScriptBridge.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import EventKit

internal struct JavaScriptBridge {
    
    // This class is needed to be able to get out bundle
    private class DummyClass {}
    
    internal static func rrulejs() -> String? {
        let libPath = Bundle(for: DummyClass.self).path(forResource: "rrule", ofType: "js") ?? Bundle.main.path(forResource: "rrule", ofType: "js")
        guard let rrulelibPath = libPath else {
            return nil
        }

        do {
            return try String(contentsOfFile: rrulelibPath)
        } catch _ {
            return nil
        }
    }
}

internal extension RecurrenceFrequency {
    fileprivate func toJSONFrequency() -> String {
        switch self {
        case .secondly: return "RRule.SECONDLY"
        case .minutely: return "RRule.MINUTELY"
        case .hourly: return "RRule.HOURLY"
        case .daily: return "RRule.DAILY"
        case .weekly: return "RRule.WEEKLY"
        case .monthly: return "RRule.MONTHLY"
        case .yearly: return "RRule.YEARLY"
        }
    }
}

internal extension EKWeekday {
    fileprivate func toJSONSymbol() -> String {
        switch self {
        case .monday: return "RRule.MO"
        case .tuesday: return "RRule.TU"
        case .wednesday: return "RRule.WE"
        case .thursday: return "RRule.TH"
        case .friday: return "RRule.FR"
        case .saturday: return "RRule.SA"
        case .sunday: return "RRule.SU"
        }
    }
}

internal extension RecurrenceRule {
    internal func toJSONString(endless endlessRecurrenceCount: Int) -> String {
        var jsonString = "freq: \(frequency.toJSONFrequency()),"
        jsonString += "interval: \(max(1, interval)),"
        jsonString += "wkst: \(firstDayOfWeek.toJSONSymbol()),"
        jsonString += "dtstart: new Date('\(RRule.ISO8601DateFormatter.string(from: startDate))'),"

        if let endDate = recurrenceEnd?.endDate {
            jsonString += "until: new Date('\(RRule.ISO8601DateFormatter.string(from: endDate))'),"
        } else if let count = recurrenceEnd?.occurrenceCount {
            jsonString += "count: \(count),"
        } else {
            jsonString += "count: \(endlessRecurrenceCount),"
        }

        let bysetposStrings = bysetpos.flatMap({ (setpo) -> String? in
            guard (-366...366 ~= setpo) && (setpo != 0) else {
                return nil
            }
            return String(setpo)
        })
        if bysetposStrings.count > 0 {
            jsonString += "bysetpos: [\(bysetposStrings.joined(separator: ","))],"
        }

        let byyeardayStrings = byyearday.flatMap({ (yearday) -> String? in
            guard (-366...366 ~= yearday) && (yearday != 0) else {
                return nil
            }
            return String(yearday)
        })
        if byyeardayStrings.count > 0 {
            jsonString += "byyearday: [\(byyeardayStrings.joined(separator: ","))],"
        }

        let bymonthStrings = bymonth.flatMap({ (month) -> String? in
            guard 1...12 ~= month else {
                return nil
            }
            return String(month)
        })
        if bymonthStrings.count > 0 {
            jsonString += "bymonth: [\(bymonthStrings.joined(separator: ","))],"
        }

        let byweeknoStrings = byweekno.flatMap({ (weekno) -> String? in
            guard (-53...53 ~= weekno) && (weekno != 0) else {
                return nil
            }
            return String(weekno)
        })
        if byweeknoStrings.count > 0 {
            jsonString += "byweekno: [\(byweeknoStrings.joined(separator: ","))],"
        }

        let bymonthdayStrings = bymonthday.flatMap({ (monthday) -> String? in
            guard (-31...31 ~= monthday) && (monthday != 0) else {
                return nil
            }
            return String(monthday)
        })
        if bymonthdayStrings.count > 0 {
            jsonString += "bymonthday: [\(bymonthdayStrings.joined(separator: ","))],"
        }

        let byweekdayJSSymbols = byweekday.map({ (weekday) -> String in
            return weekday.toJSONSymbol()
        })
        if byweekdayJSSymbols.count > 0 {
            jsonString += "byweekday: [\(byweekdayJSSymbols.joined(separator: ","))],"
        }

        let byhourStrings = byhour.map({ (hour) -> String in
            return String(hour)
        })
        if byhourStrings.count > 0 {
            jsonString += "byhour: [\(byhourStrings.joined(separator: ","))],"
        }

        let byminuteStrings = byminute.map({ (minute) -> String in
            return String(minute)
        })
        if byminuteStrings.count > 0 {
            jsonString += "byminute: [\(byminuteStrings.joined(separator: ","))],"
        }

        let bysecondStrings = bysecond.map({ (second) -> String in
            return String(second)
        })
        if bysecondStrings.count > 0 {
            jsonString += "bysecond: [\(bysecondStrings.joined(separator: ","))]"
        }

        if String(jsonString.suffix(from: jsonString.characters.index(jsonString.endIndex, offsetBy: -1))) == "," {
            jsonString.remove(at: jsonString.characters.index(jsonString.endIndex, offsetBy: -1))
        }

        return jsonString
    }
}
