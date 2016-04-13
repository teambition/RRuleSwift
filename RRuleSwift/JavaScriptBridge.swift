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
    internal static func rrulejs() -> String? {
        let libPath = NSBundle(identifier: "Teambition.RRuleSwift")?.pathForResource("rrule", ofType: "js") ?? NSBundle.mainBundle().pathForResource("rrule", ofType: "js")
        guard let rrulelibPath = libPath else {
            return nil
        }

        do {
            let rrulejs = try NSString(contentsOfFile: rrulelibPath, encoding: NSUTF8StringEncoding) as String
            return rrulejs
        } catch _ {
            return nil
        }
    }
}

internal extension RecurrenceFrequency {
    private func toJSONFrequency() -> String {
        switch self {
        case .Secondly: return "RRule.SECONDLY"
        case .Minutely: return "RRule.MINUTELY"
        case .Hourly: return "RRule.HOURLY"
        case .Daily: return "RRule.DAILY"
        case .Weekly: return "RRule.WEEKLY"
        case .Monthly: return "RRule.MONTHLY"
        case .Yearly: return "RRule.YEARLY"
        }
    }
}

internal extension EKWeekday {
    private func toJSONSymbol() -> String {
        switch self {
        case .Monday: return "RRule.MO"
        case .Tuesday: return "RRule.TU"
        case .Wednesday: return "RRule.WE"
        case .Thursday: return "RRule.TH"
        case .Friday: return "RRule.FR"
        case .Saturday: return "RRule.SA"
        case .Sunday: return "RRule.SU"
        }
    }
}

internal extension RecurrenceRule {
    internal func toJSONString() -> String {
        var jsonString = "freq: \(frequency.toJSONFrequency()),"
        jsonString += "interval: \(max(1, interval)),"
        jsonString += "wkst: \(firstDayOfWeek.toJSONSymbol()),"
        jsonString += "dtstart: new Date('\(RRule.ISO8601DateFormatter.stringFromDate(startDate))'),"

        if let endDate = recurrenceEnd?.endDate {
            jsonString += "until: new Date('\(RRule.ISO8601DateFormatter.stringFromDate(endDate))'),"
        } else if let count = recurrenceEnd?.occurrenceCount {
            jsonString += "count: \(count),"
        } else {
            jsonString += "count: \(Generator.endlessRecurrenceCount),"
        }

        let bysetposStrings = bysetpos.flatMap({ (setpo) -> String? in
            guard (-366...366 ~= setpo) && (setpo != 0) else {
                return nil
            }
            return String(setpo)
        })
        if bysetposStrings.count > 0 {
            jsonString += "bysetpos: [\(bysetposStrings.joinWithSeparator(","))],"
        }

        let byyeardayStrings = byyearday.flatMap({ (yearday) -> String? in
            guard (-366...366 ~= yearday) && (yearday != 0) else {
                return nil
            }
            return String(yearday)
        })
        if byyeardayStrings.count > 0 {
            jsonString += "byyearday: [\(byyeardayStrings.joinWithSeparator(","))],"
        }

        let bymonthStrings = bymonth.flatMap({ (month) -> String? in
            guard 1...12 ~= month else {
                return nil
            }
            return String(month)
        })
        if bymonthStrings.count > 0 {
            jsonString += "bymonth: [\(bymonthStrings.joinWithSeparator(","))],"
        }

        let byweeknoStrings = byweekno.flatMap({ (weekno) -> String? in
            guard (-53...53 ~= weekno) && (weekno != 0) else {
                return nil
            }
            return String(weekno)
        })
        if byweeknoStrings.count > 0 {
            jsonString += "byweekno: [\(byweeknoStrings.joinWithSeparator(","))],"
        }

        let bymonthdayStrings = bymonthday.flatMap({ (monthday) -> String? in
            guard (-31...31 ~= monthday) && (monthday != 0) else {
                return nil
            }
            return String(monthday)
        })
        if bymonthdayStrings.count > 0 {
            jsonString += "bymonthday: [\(bymonthdayStrings.joinWithSeparator(","))],"
        }

        let byweekdayJSSymbols = byweekday.map({ (weekday) -> String in
            return weekday.toJSONSymbol()
        })
        if byweekdayJSSymbols.count > 0 {
            jsonString += "byweekday: [\(byweekdayJSSymbols.joinWithSeparator(","))],"
        }

        let byhourStrings = byhour.map({ (hour) -> String in
            return String(hour)
        })
        if byhourStrings.count > 0 {
            jsonString += "byhour: [\(byhourStrings.joinWithSeparator(","))],"
        }

        let byminuteStrings = byminute.map({ (minute) -> String in
            return String(minute)
        })
        if byminuteStrings.count > 0 {
            jsonString += "byminute: [\(byminuteStrings.joinWithSeparator(","))],"
        }

        let bysecondStrings = bysecond.map({ (second) -> String in
            return String(second)
        })
        if bysecondStrings.count > 0 {
            jsonString += "bysecond: [\(bysecondStrings.joinWithSeparator(","))]"
        }

        if jsonString.substringFromIndex(jsonString.endIndex.advancedBy(-1)) == "," {
            jsonString.removeAtIndex(jsonString.endIndex.advancedBy(-1))
        }

        return jsonString
    }
}
