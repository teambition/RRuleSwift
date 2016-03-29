//
//  RecurrenceRule.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation
import EventKit

public struct RecurrenceRule {
    /// The calendar of recurrence rule.
    public var calendar = NSCalendar.currentCalendar()

    /// The frequency of the recurrence rule.
    public var frequency: RecurrenceFrequency?

    /// Specifies how often the recurrence rule repeats over the unit of time indicated by its frequency. For example, a recurrence rule with a frequency type of RecurrenceFrequency.Weekly and an interval of 2 repeats every two weeks.
    ///
    /// The default value of this property is 1.
    public var interval = 1

    /// Indicates which day of the week the recurrence rule treats as the first day of the week. 
    ///
    /// The default value of this property is EKWeekday.Monday.
    public var firstDayOfWeek: EKWeekday = .Monday

    /// The start date of recurrence rule.
    ///
    /// The default value of this property is current date.
    public var startDate = NSDate()

    /// Indicates when the recurrence rule ends. This can be represented by an end date or a number of occurrences.
    public var recurrenceEnd: EKRecurrenceEnd?

    /// An array of ordinal integers that filters which recurrences to include in the recurrence rule’s frequency. Values can be from 1 to 366 and from -1 to -366.
    ///
    /// For example, if a bysetpos of -1 is combined with a RecurrenceFrequency.Monthly frequency, and a byweekday of (EKWeekday.Monday, EKWeekday.Tuesday, EKWeekday.Wednesday, EKWeekday.Thursday, EKWeekday.Friday), will result in the last work day of every month.
    ///
    /// Negative values indicate counting backwards from the end of the recurrence rule’s frequency.
    public var bysetpos: [Int]?

    /// The days of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 366 and from -1 to -366.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific days of the year and a frequency type of RecurrenceFrequency.Yearly.
    ///
    /// Negative values indicate counting backwards from the end of the year.
    public var byyearday: [Int]?

    /// The months of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 12. 
    ///
    /// This property value is valid only for recurrence rules initialized with specific months of the year and a frequency type of RecurrenceFrequency.Yearly.
    public var bymonth: [Int]?

    /// The weeks of the year associated with the recurrence rule, as an array of integers.  Values can be from 1 to 53 and from -1 to -53. According to ISO8601, the first week of the year is that containing at least four days of the new year.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific weeks of the year and a frequency type of RecurrenceFrequency.Yearly.
    ///
    /// Negative values indicate counting backwards from the end of the year.
    public var byweekno: [Int]?

    /// The days of the month associated with the recurrence rule, as an array of integers. Values can be from 1 to 31 and from -1 to -31.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific days of the month and a frequency type of RecurrenceFrequency.Monthly.
    ///
    /// Negative values indicate counting backwards from the end of the month.
    public var bymonthday: [Int]?

    /// The days of the week associated with the recurrence rule, as an array of EKWeekday objects.
    public var byweekday: [EKWeekday]?

    /// The hours of the day associated with the recurrence rule, as an array of integers. Values can be from 0 to 23.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific hours of the day and a frequency type of RecurrenceFrequency.Day
    public var byhour: [Int]?

    /// The minutes of the hour associated with the recurrence rule, as an array of integers. Values can be from 0 to 59.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific minutes of the hour and a frequency type of RecurrenceFrequency.Hour.
    public var byminute: [Int]?

    /// The seconds of the minute associated with the recurrence rule, as an array of integers. Values can be from 0 to 59.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific seconds of the minute and a frequency type of RecurrenceFrequency.Minute.
    public var bysecond: [Int]?

    public init() { }

    public func toRRuleString() -> String {
        return RRule.stringFromRule(self)
    }

    public static func ruleWithString(rruleString: String) -> RecurrenceRule? {
        return RRule.ruleFromString(rruleString)
    }
}

extension RecurrenceRule {
    public func occurrencesBetween(date beginDate: NSDate, andDate untilDate: NSDate) -> [NSDate] {
        guard let frequency = frequency else {
            return []
        }

//        let startDateComponents = calendar.components(Generator.componentFlags, fromDate: startDate)
//        var day = startDateComponents.day
//        var month = startDateComponents.month
//        var year = startDateComponents.year
        switch frequency {
        case .Yearly:
            return []
        case .Monthly:
            return []
        case .Weekly:
            return []
        case .Daily:
            return []
        case .Hourly:
            return []
        case .Minutely:
            return []
        case .Secondly:
            return []
        }
    }
}
