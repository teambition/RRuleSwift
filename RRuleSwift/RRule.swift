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
    public static var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        return dateFormatter
    }

    public static func ruleFormString(string: String) -> RecurrenceRule? {
        let string = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        guard let range = string.rangeOfString("RRULE:") where range.startIndex == string.startIndex else {
            return nil
        }
        let ruleString = string.substringFromIndex(range.endIndex)
        let rules = ruleString.componentsSeparatedByString(";").flatMap { (rule) -> String? in
            if (rule.isEmpty || rule.characters.count == 0) {
                return nil
            }
            return rule
        }

        var recurrenceRule = RecurrenceRule()
        for rule in rules {
            let ruleComponents = rule.componentsSeparatedByString("=")
            guard ruleComponents.count == 2 else {
                continue
            }
            let ruleName = ruleComponents[0]
            let ruleValue = ruleComponents[2]
            guard !ruleValue.isEmpty && ruleValue.characters.count > 0 else {
                continue
            }

            if ruleName == "FREQ" {
                recurrenceRule.frequency = RecurrenceFrequency.frequencyFromString(ruleValue)
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
                if let startDate = dateFormatter.dateFromString(ruleValue) {
                    recurrenceRule.startDate = startDate
                }
            }

            if ruleName == "UNTIL" {
                if let endDate = dateFormatter.dateFromString(ruleValue) {
                    recurrenceRule.recurrenceEnd = EKRecurrenceEnd(endDate: endDate)
                }
            }

            if ruleName == "COUNT" {
                if let count = Int(ruleValue) {
                    recurrenceRule.recurrenceEnd = EKRecurrenceEnd(occurrenceCount: count)
                }
            }

            if ruleName == "BYSETPOS" {
                let bysetpos = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.bysetpos = bysetpos.sort(<)
            }

            if ruleName == "BYYEARDAY" {
                let byyearday = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.byyearday = byyearday.sort(<)
            }

            if ruleName == "BYMONTH" {
                let bymonth = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.bymonth = bymonth.sort(<)
            }

            if ruleName == "BYWEEKNO" {
                let byweekno = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.byweekno = byweekno.sort(<)
            }

            if ruleName == "BYMONTHDAY" {
                let bymonthday = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.bymonthday = bymonthday.sort(<)
            }

            if ruleName == "BYDAY" {
                // These variables will define the weekdays where the recurrence will be applied.
                // In the RFC documentation, it is specified as BYDAY, but was renamed to avoid the ambiguity of that argument.
                let byweekday = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> EKWeekday? in
                    return EKWeekday.weekdayFromSymbol(string)
                })
                recurrenceRule.byweekday = byweekday.sort(<)
            }

            if ruleName == "BYHOUR" {
                let byhour = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.byhour = byhour.sort(<)
            }

            if ruleName == "BYMINUTE" {
                let byminute = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.byminute = byminute.sort(<)
            }

            if ruleName == "BYSECOND" {
                let bysecond = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(ruleValue)
                })
                recurrenceRule.bysecond = bysecond.sort(<)
            }
        }

        return recurrenceRule
    }

    public static func stringFromRule(rule: RecurrenceRule) -> String {
        var rruleString = "RRULE:"

        if let frequency = rule.frequency {
            rruleString += "FREQ=\(frequency.toString());"
        }

        let interval = max(1, rule.interval)
        rruleString += "INTERVAL=\(interval);"

        rruleString += "WKST=\(rule.firstDayOfWeek.toSymbol());"

        if let startDate = rule.startDate {
            rruleString += "DTSTART=\(dateFormatter.stringFromDate(startDate));"
        }

        if let endDate = rule.recurrenceEnd?.endDate {
            rruleString += "UNTIL=\(dateFormatter.stringFromDate(endDate));"
        }

        if let count = rule.recurrenceEnd?.occurrenceCount {
            rruleString += "COUNT=\(count);"
        }

        if let bysetpos = rule.bysetpos {
            let bysetposStrings = bysetpos.map({ (setpo) -> String in
                return String(setpo)
            })
            rruleString += "BYSETPOS=\(bysetposStrings.joinWithSeparator(","));"
        }

        if let byyearday = rule.byyearday {
            let byyeardayStrings = byyearday.map({ (yearday) -> String in
                return String(yearday)
            })
            rruleString += "BYYEARDAY=\(byyeardayStrings.joinWithSeparator(","));"
        }

        if let bymonth = rule.bymonth {
            let bymonthStrings = bymonth.map({ (month) -> String in
                return String(month)
            })
            rruleString += "BYMONTH=\(bymonthStrings.joinWithSeparator(","));"
        }

        if let byweekno = rule.byweekno {
            let byweeknoStrings = byweekno.map({ (weekno) -> String in
                return String(weekno)
            })
            rruleString += "BYWEEKNO=\(byweeknoStrings.joinWithSeparator(","));"
        }

        if let bymonthday = rule.bymonthday {
            let bymonthdayStrings = bymonthday.map({ (monthday) -> String in
                return String(monthday)
            })
            rruleString += "BYMONTHDAY=\(bymonthdayStrings.joinWithSeparator(","));"
        }

        if let byweekday = rule.byweekday {
            let byweekdaySymbols = byweekday.map({ (weekday) -> String in
                return weekday.toSymbol()
            })
            rruleString += "BYDAY=\(byweekdaySymbols.joinWithSeparator(","));"
        }

        if let byhour = rule.byhour {
            let byhourStrings = byhour.map({ (hour) -> String in
                return String(hour)
            })
            rruleString += "BYHOUR=\(byhourStrings.joinWithSeparator(","));"
        }

        if let byminute = rule.byminute {
            let byminuteStrings = byminute.map({ (minute) -> String in
                return String(minute)
            })
            rruleString += "BYMINUTE=\(byminuteStrings.joinWithSeparator(","));"
        }

        if let bysecond = rule.bysecond {
            let bysecondStrings = bysecond.map({ (second) -> String in
                return String(second)
            })
            rruleString += "BYSECOND=\(bysecondStrings.joinWithSeparator(","));"
        }

        if rruleString.substringFromIndex(rruleString.endIndex.advancedBy(1)) == ";" {
            rruleString.removeAtIndex(rruleString.endIndex)
        }

        return rruleString
    }
}
