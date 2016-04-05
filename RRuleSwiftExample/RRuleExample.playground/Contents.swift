//: Playground - noun: a place where people can play

import UIKit
import EventKit
import RRuleSwift

let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
    return dateFormatter
}()

let ruleString1 = "RRULE:FREQ=WEEKLY;DTSTART=20160328T070000Z;BYDAY=MO,TU,WE,TH,FR;INTERVAL=1"
if let rule1 = RecurrenceRule.ruleWithString(ruleString1) {
    let weekdays = rule1.byweekday!.map({ (weekday) -> Int in
        return weekday.rawValue
    })
    print(weekdays)
}

let ruleString2 = "RRULE:FREQ=YEARLY;COUNT=5;WKST=MO"
if let rule2 = RecurrenceRule.ruleWithString(ruleString2) {
    let dates = rule2.allOccurrences().map({ (date) -> String in
        return dateFormatter.stringFromDate(date)
    })
}
