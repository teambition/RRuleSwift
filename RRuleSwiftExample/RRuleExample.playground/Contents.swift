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
    let weekdays = rule1.byweekday.map({ (weekday) -> Int in
        return weekday.rawValue
    })
}

let rdateString = "RDATE:20160701T023000Z,20120702T023000Z"
if let inclusionDate = InclusionDate(rdateString: rdateString) {
    let rdates = inclusionDate.dates
}

let exdateString = "EXDATE:20160416T030000Z,20160420T030000Z"
if let exclusionDate = ExclusionDate(exdateString: exdateString, unitGranularity: .Day) {
    let exdates = exclusionDate.dates
}

let rdate1 = dateFormatter.dateFromString("2018-07-07 00:00:00 Sun")!
let rdate2 = dateFormatter.dateFromString("2021-07-07 00:00:00 Sun")!
let ruleInclusionDate = InclusionDate(dates: [rdate1, rdate2])
let ruleRDateString = ruleInclusionDate.toRDateString()

let exdate1 = dateFormatter.dateFromString("2019-01-01 00:00:00 Sun")!
let exdate2 = dateFormatter.dateFromString("2021-01-01 00:00:00 Wed")!
let ruleExclusionDate = ExclusionDate(dates: [exdate1, exdate2], unitGranularity: .Year)
let ruleExDateString = ruleExclusionDate.toExDateString()


let ruleString2 = "RRULE:FREQ=YEARLY;COUNT=11;WKST=MO"
if let rule2 = RecurrenceRule(recurrenceWithRRuleString: ruleString2) {
    var rule2 = rule2
    rule2.exdate = ruleExclusionDate
    rule2.rdate = ruleInclusionDate
    let allDates = rule2.allOccurrences().map({ (date) -> String in
        return dateFormatter.stringFromDate(date)
    })

    let date = dateFormatter.dateFromString("2018-01-01 00:00:00 Sun")
    let otherDate = dateFormatter.dateFromString("2024-01-01 00:00:00 Mon")
    let betweenDates = rule2.occurrencesBetween(date: date!, andDate: otherDate!).map({ (date) -> String in
        return dateFormatter.stringFromDate(date)
    })
}
