//: Playground - noun: a place where people can play

import UIKit
import EventKit
import RRuleSwift

let dateFormatter: NSDateFormatter = {
    let dateFormatter = NSDateFormatter()
    dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
    dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
    return dateFormatter
}()

let ruleString1 = "RRULE:FREQ=WEEKLY;DTSTART=20160328T070000Z;BYDAY=MO,TU,WE,TH,FR;INTERVAL=1"
if let rule1 = RecurrenceRule(recurrenceWithRRuleString: ruleString1) {
    let weekdays = rule1.byweekday!.map({ (weekday) -> Int in
        return weekday.rawValue
    })
}

let ruleString2 = "RRULE:FREQ=YEARLY;COUNT=5;WKST=MO"
if let rule2 = RecurrenceRule(recurrenceWithRRuleString: ruleString2) {
    let allDates = rule2.allOccurrences().map({ (date) -> String in
        return dateFormatter.stringFromDate(date)
    })

    let date = dateFormatter.dateFromString("2017-01-01 00:00:00 Sun")
    let otherDate = dateFormatter.dateFromString("2020-01-01 00:00:00 Wed")
    let betweenDates = rule2.occurrencesBetween(date: date!, andDate: otherDate!).map({ (date) -> String in
        return dateFormatter.stringFromDate(date)
    })
}
