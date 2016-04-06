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

    internal static var ISO8601DateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return dateFormatter
    }

    public static func ruleFromString(string: String) -> RecurrenceRule? {
        let string = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        guard let range = string.rangeOfString("RRULE:") where range.startIndex == string.startIndex else {
            print("error: invalid rule string, must be started with 'RRULE:'")
            return nil
        }
        let ruleString = string.substringFromIndex(range.endIndex)
        let rules = ruleString.componentsSeparatedByString(";").flatMap { (rule) -> String? in
            if (rule.isEmpty || rule.characters.count == 0) {
                return nil
            }
            return rule
        }

        var recurrenceRule = RecurrenceRule(recurrenceWithFrequency: .Daily)
        var ruleFrequency: RecurrenceFrequency?
        for rule in rules {
            let ruleComponents = rule.componentsSeparatedByString("=")
            guard ruleComponents.count == 2 else {
                continue
            }
            let ruleName = ruleComponents[0]
            let ruleValue = ruleComponents[1]
            guard !ruleValue.isEmpty && ruleValue.characters.count > 0 else {
                continue
            }

            if ruleName == "FREQ" {
                ruleFrequency = RecurrenceFrequency.frequencyFromString(ruleValue)
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
            } else if ruleName == "COUNT" {
                if let count = Int(ruleValue) {
                    recurrenceRule.recurrenceEnd = EKRecurrenceEnd(occurrenceCount: count)
                }
            }

            if ruleName == "BYSETPOS" {
                let bysetpos = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    guard let setpo = Int(string) where (-366...366 ~= setpo) && (setpo != 0) else {
                        return nil
                    }
                    return setpo
                })
                recurrenceRule.bysetpos = bysetpos.sort(<)
            }

            if ruleName == "BYYEARDAY" {
                let byyearday = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    guard let yearday = Int(string) where (-366...366 ~= yearday) && (yearday != 0) else {
                        return nil
                    }
                    return yearday
                })
                recurrenceRule.byyearday = byyearday.sort(<)
            }

            if ruleName == "BYMONTH" {
                let bymonth = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    guard let month = Int(string) where 1...12 ~= month else {
                        return nil
                    }
                    return month
                })
                recurrenceRule.bymonth = bymonth.sort(<)
            }

            if ruleName == "BYWEEKNO" {
                let byweekno = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    guard let weekno = Int(string) where (-53...53 ~= weekno) && (weekno != 0) else {
                        return nil
                    }
                    return weekno
                })
                recurrenceRule.byweekno = byweekno.sort(<)
            }

            if ruleName == "BYMONTHDAY" {
                let bymonthday = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    guard let monthday = Int(string) where (-31...31 ~= monthday) && (monthday != 0) else {
                        return nil
                    }
                    return monthday
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
                    return Int(string)
                })
                recurrenceRule.byhour = byhour.sort(<)
            }

            if ruleName == "BYMINUTE" {
                let byminute = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(string)
                })
                recurrenceRule.byminute = byminute.sort(<)
            }

            if ruleName == "BYSECOND" {
                let bysecond = ruleValue.componentsSeparatedByString(",").flatMap({ (string) -> Int? in
                    return Int(string)
                })
                recurrenceRule.bysecond = bysecond.sort(<)
            }
        }

        guard let frequency = ruleFrequency else {
            print("error: invalid frequency")
            return nil
        }
        recurrenceRule.frequency = frequency

        return recurrenceRule
    }

    public static func stringFromRule(rule: RecurrenceRule) -> String {
        var rruleString = "RRULE:"

        rruleString += "FREQ=\(rule.frequency.toString());"

        let interval = max(1, rule.interval)
        rruleString += "INTERVAL=\(interval);"

        rruleString += "WKST=\(rule.firstDayOfWeek.toSymbol());"

        rruleString += "DTSTART=\(dateFormatter.stringFromDate(rule.startDate));"

        if let endDate = rule.recurrenceEnd?.endDate {
            rruleString += "UNTIL=\(dateFormatter.stringFromDate(endDate));"
        } else if let count = rule.recurrenceEnd?.occurrenceCount {
            rruleString += "COUNT=\(count);"
        }

        if let bysetpos = rule.bysetpos {
            let bysetposStrings = bysetpos.flatMap({ (setpo) -> String? in
                guard (-366...366 ~= setpo) && (setpo != 0) else {
                    return nil
                }
                return String(setpo)
            })
            if bysetposStrings.count > 0 {
                rruleString += "BYSETPOS=\(bysetposStrings.joinWithSeparator(","));"
            }
        }

        if let byyearday = rule.byyearday {
            let byyeardayStrings = byyearday.flatMap({ (yearday) -> String? in
                guard (-366...366 ~= yearday) && (yearday != 0) else {
                    return nil
                }
                return String(yearday)
            })
            if byyeardayStrings.count > 0 {
                rruleString += "BYYEARDAY=\(byyeardayStrings.joinWithSeparator(","));"
            }
        }

        if let bymonth = rule.bymonth {
            let bymonthStrings = bymonth.flatMap({ (month) -> String? in
                guard 1...12 ~= month else {
                    return nil
                }
                return String(month)
            })
            if bymonthStrings.count > 0 {
                rruleString += "BYMONTH=\(bymonthStrings.joinWithSeparator(","));"
            }
        }

        if let byweekno = rule.byweekno {
            let byweeknoStrings = byweekno.flatMap({ (weekno) -> String? in
                guard (-53...53 ~= weekno) && (weekno != 0) else {
                    return nil
                }
                return String(weekno)
            })
            if byweeknoStrings.count > 0 {
                rruleString += "BYWEEKNO=\(byweeknoStrings.joinWithSeparator(","));"
            }
        }

        if let bymonthday = rule.bymonthday {
            let bymonthdayStrings = bymonthday.flatMap({ (monthday) -> String? in
                guard (-31...31 ~= monthday) && (monthday != 0) else {
                    return nil
                }
                return String(monthday)
            })
            if bymonthdayStrings.count > 0 {
                rruleString += "BYMONTHDAY=\(bymonthdayStrings.joinWithSeparator(","));"
            }
        }

        if let byweekday = rule.byweekday {
            let byweekdaySymbols = byweekday.map({ (weekday) -> String in
                return weekday.toSymbol()
            })
            if byweekdaySymbols.count > 0 {
                rruleString += "BYDAY=\(byweekdaySymbols.joinWithSeparator(","));"
            }
        }

        if let byhour = rule.byhour {
            let byhourStrings = byhour.map({ (hour) -> String in
                return String(hour)
            })
            if byhourStrings.count > 0 {
                rruleString += "BYHOUR=\(byhourStrings.joinWithSeparator(","));"
            }
        }

        if let byminute = rule.byminute {
            let byminuteStrings = byminute.map({ (minute) -> String in
                return String(minute)
            })
            if byminuteStrings.count > 0 {
                rruleString += "BYMINUTE=\(byminuteStrings.joinWithSeparator(","));"
            }
        }

        if let bysecond = rule.bysecond {
            let bysecondStrings = bysecond.map({ (second) -> String in
                return String(second)
            })
            if bysecondStrings.count > 0 {
                rruleString += "BYSECOND=\(bysecondStrings.joinWithSeparator(","));"
            }
        }

        if rruleString.substringFromIndex(rruleString.endIndex.advancedBy(-1)) == ";" {
            rruleString.removeAtIndex(rruleString.endIndex.advancedBy(-1))
        }

        return rruleString
    }
}
