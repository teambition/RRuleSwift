//
//  Generators.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/29.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import JavaScriptCore

internal struct Generator {
    static let endlessRecurrenceCount = 500
}

public extension RecurrenceRule {
    public func allOccurrences() -> [NSDate] {
        guard let rrulejs = JavaScriptBridge.rrulejs() else {
            return []
        }

        let ruleJSONString = toJSONString()
        let context = JSContext()
        context.exceptionHandler = { context, exception in
            print("[RRuleSwift] rrule.js error: \(exception)")
        }
        context.evaluateScript(rrulejs)
        context.evaluateScript("var rule = new RRule({ \(ruleJSONString) })")
        guard let allOccurrences = context.evaluateScript("rule.all()").toArray() as? [NSDate] else {
            return []
        }
        return allOccurrences
    }

    public func occurrencesBetween(date date: NSDate, andDate otherDate: NSDate) -> [NSDate] {
        guard let rrulejs = JavaScriptBridge.rrulejs() else {
            return []
        }

        let beginDate = date.isBeforeOrSameWith(otherDate) ? date : otherDate
        let untilDate = otherDate.isAfterOrSameWith(date) ? otherDate : date
        let beginDateJSON = RRule.ISO8601DateFormatter.stringFromDate(beginDate)
        let untilDateJSON = RRule.ISO8601DateFormatter.stringFromDate(untilDate)

        let ruleJSONString = toJSONString()
        let context = JSContext()
        context.exceptionHandler = { context, exception in
            print("[RRuleSwift] rrule.js error: \(exception)")
        }
        context.evaluateScript(rrulejs)
        context.evaluateScript("var rule = new RRule({ \(ruleJSONString) })")
        guard let occurrences = context.evaluateScript("rule.between(new Date('\(beginDateJSON)'), new Date('\(untilDateJSON)'))").toArray() as? [NSDate] else {
            return []
        }
        return occurrences
    }
}
