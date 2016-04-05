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
        let libPath = NSBundle(identifier: "Teambition.RRuleSwift")?.pathForResource("rrule", ofType: "js") ?? NSBundle.mainBundle().pathForResource("rrule", ofType: "js")
        guard let rrulelibPath = libPath else {
            return []
        }

        do {
            guard let rrulejs = try NSString(contentsOfFile: rrulelibPath, encoding: NSUTF8StringEncoding) as? String else {
                return []
            }
            guard let ruleJSONString = toJSONString() else {
                return []
            }

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
        } catch _ {
            return []
        }
    }

    public func occurrencesBetween(date date: NSDate, andDate otherDate: NSDate) -> [NSDate] {
        let libPath = NSBundle(identifier: "Teambition.RRuleSwift")?.pathForResource("rrule", ofType: "js") ?? NSBundle.mainBundle().pathForResource("rrule", ofType: "js")
        guard let rrulelibPath = libPath else {
            return []
        }

        do {
            guard let rrulejs = try NSString(contentsOfFile: rrulelibPath, encoding: NSUTF8StringEncoding) as? String else {
                return []
            }
            guard let ruleJSONString = toJSONString() else {
                return []
            }

            let context = JSContext()
            context.exceptionHandler = { context, exception in
                print("[RRuleSwift] rrule.js error: \(exception)")
            }
            context.evaluateScript(rrulejs)
            context.evaluateScript("var rule = new RRule({ \(ruleJSONString) })")
            let dateJSON = RRule.ISO8601DateFormatter.stringFromDate(date)
            let otherDateJSON = RRule.ISO8601DateFormatter.stringFromDate(otherDate)
            guard let allOccurrences = context.evaluateScript("rule.between('\(dateJSON)'), new Date('\(otherDateJSON)')").toArray() as? [NSDate] else {
                return []
            }
            return allOccurrences
        } catch _ {
            return []
        }
    }
}