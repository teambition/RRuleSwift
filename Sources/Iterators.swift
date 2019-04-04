//
//  Iterators.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/29.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import JavaScriptCore

public struct Iterator {
    public static let endlessRecurrenceCount = 500
    internal static let rruleContext: JSContext? = {
        guard let rrulejs = JavaScriptBridge.rrulejs() else {
            return nil
        }
        let context = JSContext()
        context?.exceptionHandler = { context, exception in
            print("[RRuleSwift] rrule.js error: \(String(describing: exception))")
        }
        let _ = context?.evaluateScript(rrulejs)
        return context
    }()
}

public extension RecurrenceRule {
    func allOccurrences(endless endlessRecurrenceCount: Int = Iterator.endlessRecurrenceCount) -> [Date] {
        guard let _ = JavaScriptBridge.rrulejs() else {
            return []
        }

        let ruleJSONString = toJSONString(endless: endlessRecurrenceCount)
        let _ = Iterator.rruleContext?.evaluateScript("var rule = new RRule({ \(ruleJSONString) })")
        guard let allOccurrences = Iterator.rruleContext?.evaluateScript("rule.all()").toArray() as? [Date] else {
            return []
        }

        var occurrences = allOccurrences
        if let rdates = rdate?.dates {
            occurrences.append(contentsOf: rdates)
        }

        if let exdates = exdate?.dates, let component = exdate?.component {
            for occurrence in occurrences {
                for exdate in exdates {
                    if calendar.isDate(occurrence, equalTo: exdate, toGranularity: component) {
                        let index = occurrences.firstIndex(of: occurrence)!
                        occurrences.remove(at: index)
                        break
                    }
                }
            }
        }

        return occurrences.sorted { $0.isBeforeOrSame(with: $1) }
    }

    func occurrences(between date: Date, and otherDate: Date, endless endlessRecurrenceCount: Int = Iterator.endlessRecurrenceCount) -> [Date] {
        guard let _ = JavaScriptBridge.rrulejs() else {
            return []
        }

        let beginDate = date.isBeforeOrSame(with: otherDate) ? date : otherDate
        let untilDate = otherDate.isAfterOrSame(with: date) ? otherDate : date
        let beginDateJSON = RRule.ISO8601DateFormatter.string(from: beginDate)
        let untilDateJSON = RRule.ISO8601DateFormatter.string(from: untilDate)

        let ruleJSONString = toJSONString(endless: endlessRecurrenceCount)
        let _ = Iterator.rruleContext?.evaluateScript("var rule = new RRule({ \(ruleJSONString) })")
        guard let betweenOccurrences = Iterator.rruleContext?.evaluateScript("rule.between(new Date('\(beginDateJSON)'), new Date('\(untilDateJSON)'))").toArray() as? [Date] else {
            return []
        }

        var occurrences = betweenOccurrences
        if let rdates = rdate?.dates {
            occurrences.append(contentsOf: rdates)
        }

        if let exdates = exdate?.dates, let component = exdate?.component {
            for occurrence in occurrences {
                for exdate in exdates {
                    if calendar.isDate(occurrence, equalTo: exdate, toGranularity: component) {
                        let index = occurrences.firstIndex(of: occurrence)!
                        occurrences.remove(at: index)
                        break
                    }
                }
            }
        }

        return occurrences.sorted { $0.isBeforeOrSame(with: $1) }
    }
}
