//
//  RRule.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import EventKit

public struct RRule {
    public static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFormatter
    }()
    public static let ymdDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter
    }()

    internal static let ISO8601DateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }()

    public static func ruleFromString(_ string: String) -> RecurrenceRule? {
        let string = string.trimmingCharacters(in: .whitespaces)
        guard let range = string.range(of: "RRULE:"), range.lowerBound == string.startIndex else {
            return nil
        }
        let ruleString = String(string.suffix(from: range.upperBound))
        let rules = ruleString.components(separatedBy: ";").compactMap { (rule) -> String? in
            if rule.isEmpty {
                return nil
            }
            return rule
        }

        var recurrenceRule = RecurrenceRule(frequency: .daily)
        var ruleFrequency: RecurrenceFrequency?
        for rule in rules {
            let ruleComponents = rule.components(separatedBy: "=")
            guard ruleComponents.count == 2 else {
                continue
            }
            let ruleName = ruleComponents[0]
            let ruleValue = ruleComponents[1]
            guard !ruleValue.isEmpty else {
                continue
            }

            if ruleName == "FREQ" {
                ruleFrequency = RecurrenceFrequency.frequency(from: ruleValue)
            }

            if ruleName == "INTERVAL" {
                if let interval = Int(ruleValue) {
                    recurrenceRule.interval = max(1, interval)
                }
            }

            if ruleName == "WKST" {
                if let firstDayOfWeek = EKWeekday.weekdayFromSymbol(ruleValue) {
                    recurrenceRule.firstDayOfWeek = firstDayOfWeek
                }
            }

            if ruleName == "DTSTART" {
                if let startDate = dateFormatter.date(from: ruleValue) {
                    recurrenceRule.startDate = startDate
                } else if let startDate = realDate(ruleValue) {
                    recurrenceRule.startDate = startDate
                }
            }

            if ruleName == "UNTIL" {
                if let endDate = dateFormatter.date(from: ruleValue) {
                    recurrenceRule.recurrenceEnd = EKRecurrenceEnd(end: endDate)
                } else if let endDate = realDate(ruleValue) {
                    recurrenceRule.recurrenceEnd = EKRecurrenceEnd(end: endDate)
                }
            } else if ruleName == "COUNT" {
                if let count = Int(ruleValue) {
                    recurrenceRule.recurrenceEnd = EKRecurrenceEnd(occurrenceCount: count)
                }
            }

            if ruleName == "BYSETPOS" {
                let bysetpos = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    guard let setpo = Int(string), (-366...366 ~= setpo) && (setpo != 0) else {
                        return nil
                    }
                    return setpo
                })
                recurrenceRule.bysetpos = bysetpos.sorted(by: <)
            }

            if ruleName == "BYYEARDAY" {
                let byyearday = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    guard let yearday = Int(string), (-366...366 ~= yearday) && (yearday != 0) else {
                        return nil
                    }
                    return yearday
                })
                recurrenceRule.byyearday = byyearday.sorted(by: <)
            }

            if ruleName == "BYMONTH" {
                let bymonth = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    guard let month = Int(string), 1...12 ~= month else {
                        return nil
                    }
                    return month
                })
                recurrenceRule.bymonth = bymonth.sorted(by: <)
            }

            if ruleName == "BYWEEKNO" {
                let byweekno = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    guard let weekno = Int(string), (-53...53 ~= weekno) && (weekno != 0) else {
                        return nil
                    }
                    return weekno
                })
                recurrenceRule.byweekno = byweekno.sorted(by: <)
            }

            if ruleName == "BYMONTHDAY" {
                let bymonthday = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    guard let monthday = Int(string), (-31...31 ~= monthday) && (monthday != 0) else {
                        return nil
                    }
                    return monthday
                })
                recurrenceRule.bymonthday = bymonthday.sorted(by: <)
            }

            if ruleName == "BYDAY" {
                // These variables will define the weekdays where the recurrence will be applied.
                // In the RFC documentation, it is specified as BYDAY, but was renamed to avoid the ambiguity of that argument.
                let byweekday = ruleValue.components(separatedBy: ",").compactMap({ (string) -> EKWeekday? in
                    return EKWeekday.weekdayFromSymbol(string)
                })
                recurrenceRule.byweekday = byweekday.sorted(by: <)
            }

            if ruleName == "BYHOUR" {
                let byhour = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    return Int(string)
                })
                recurrenceRule.byhour = byhour.sorted(by: <)
            }

            if ruleName == "BYMINUTE" {
                let byminute = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    return Int(string)
                })
                recurrenceRule.byminute = byminute.sorted(by: <)
            }

            if ruleName == "BYSECOND" {
                let bysecond = ruleValue.components(separatedBy: ",").compactMap({ (string) -> Int? in
                    return Int(string)
                })
                recurrenceRule.bysecond = bysecond.sorted(by: <)
            }
        }

        guard let frequency = ruleFrequency else {
            print("error: invalid frequency")
            return nil
        }
        recurrenceRule.frequency = frequency

        return recurrenceRule
    }

    public static func stringFromRule(_ rule: RecurrenceRule) -> String {
        var rruleString = "RRULE:"

        rruleString += "FREQ=\(rule.frequency.toString());"

        let interval = max(1, rule.interval)
        rruleString += "INTERVAL=\(interval);"

        rruleString += "WKST=\(rule.firstDayOfWeek.toSymbol());"

        rruleString += "DTSTART=\(dateFormatter.string(from: rule.startDate as Date));"

        if let endDate = rule.recurrenceEnd?.endDate {
            rruleString += "UNTIL=\(dateFormatter.string(from: endDate));"
        } else if let count = rule.recurrenceEnd?.occurrenceCount {
            rruleString += "COUNT=\(count);"
        }

        let bysetposStrings = rule.bysetpos.compactMap({ (setpo) -> String? in
            guard (-366...366 ~= setpo) && (setpo != 0) else {
                return nil
            }
            return String(setpo)
        })
        if bysetposStrings.count > 0 {
            rruleString += "BYSETPOS=\(bysetposStrings.joined(separator: ","));"
        }

        let byyeardayStrings = rule.byyearday.compactMap({ (yearday) -> String? in
            guard (-366...366 ~= yearday) && (yearday != 0) else {
                return nil
            }
            return String(yearday)
        })
        if byyeardayStrings.count > 0 {
            rruleString += "BYYEARDAY=\(byyeardayStrings.joined(separator: ","));"
        }

        let bymonthStrings = rule.bymonth.compactMap({ (month) -> String? in
            guard 1...12 ~= month else {
                return nil
            }
            return String(month)
        })
        if bymonthStrings.count > 0 {
            rruleString += "BYMONTH=\(bymonthStrings.joined(separator: ","));"
        }

        let byweeknoStrings = rule.byweekno.compactMap({ (weekno) -> String? in
            guard (-53...53 ~= weekno) && (weekno != 0) else {
                return nil
            }
            return String(weekno)
        })
        if byweeknoStrings.count > 0 {
            rruleString += "BYWEEKNO=\(byweeknoStrings.joined(separator: ","));"
        }

        let bymonthdayStrings = rule.bymonthday.compactMap({ (monthday) -> String? in
            guard (-31...31 ~= monthday) && (monthday != 0) else {
                return nil
            }
            return String(monthday)
        })
        if bymonthdayStrings.count > 0 {
            rruleString += "BYMONTHDAY=\(bymonthdayStrings.joined(separator: ","));"
        }

        let byweekdaySymbols = rule.byweekday.map({ (weekday) -> String in
            return weekday.toSymbol()
        })
        if byweekdaySymbols.count > 0 {
            rruleString += "BYDAY=\(byweekdaySymbols.joined(separator: ","));"
        }

        let byhourStrings = rule.byhour.map({ (hour) -> String in
            return String(hour)
        })
        if byhourStrings.count > 0 {
            rruleString += "BYHOUR=\(byhourStrings.joined(separator: ","));"
        }

        let byminuteStrings = rule.byminute.map({ (minute) -> String in
            return String(minute)
        })
        if byminuteStrings.count > 0 {
            rruleString += "BYMINUTE=\(byminuteStrings.joined(separator: ","));"
        }

        let bysecondStrings = rule.bysecond.map({ (second) -> String in
            return String(second)
        })
        if bysecondStrings.count > 0 {
            rruleString += "BYSECOND=\(bysecondStrings.joined(separator: ","));"
        }

        if String(rruleString.suffix(from: rruleString.index(rruleString.endIndex, offsetBy: -1))) == ";" {
            rruleString.remove(at: rruleString.index(rruleString.endIndex, offsetBy: -1))
        }

        return rruleString
    }
    
    static func realDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else { return nil }
        
        let date = ymdDateFormatter.date(from: dateString)
        let destinationTimeZone = NSTimeZone.local
        let sourceGMTOffset = destinationTimeZone.secondsFromGMT(for: Date())
        
        if let timeInterval = date?.timeIntervalSince1970 {
            let realOffset = timeInterval - Double(sourceGMTOffset)
            let realDate = Date(timeIntervalSince1970: realOffset)
            
            return realDate
        }
        return nil
    }
}
