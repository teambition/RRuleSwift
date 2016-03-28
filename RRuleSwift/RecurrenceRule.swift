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
    public var startDate: NSDate?

    /// Indicates when the recurrence rule ends. This can be represented by an end date or a number of occurrences.
    public var recurrenceEnd: EKRecurrenceEnd?

    /// An array of ordinal integers that filters which recurrences to include in the recurrence rule’s frequency. 
    ///
    /// For example, a yearly recurrence rule that has a daysOfTheWeek value that specifies Monday through Friday, and a setPositions array containing 2 and -1, occurs only on the second weekday and last weekday of every year.
    public var bysetpos: [Int]?

    /// The days of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 366.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific days of the year and a frequency type of RecurrenceFrequency.Yearly.
    public var byyearday: [Int]?

    /// The months of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 12. 
    ///
    /// This property value is valid only for recurrence rules initialized with specific months of the year and a frequency type of RecurrenceFrequency.Yearly.
    public var bymonth: [Int]?

    /// The weeks of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 53. According to ISO8601, the first week of the year is that containing at least four days of the new year.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific weeks of the year and a frequency type of RecurrenceFrequency.Yearly.
    public var byweekno: [Int]?

    /// The days of the month associated with the recurrence rule, as an array of integers. Values can be from 1 to 31.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific days of the month and a frequency type of RecurrenceFrequency.Monthly.
    public var bymonthday: [Int]?

    /// The days of the week associated with the recurrence rule, as an array of EKWeekday objects.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific days of the week and a frequency type of RecurrenceFrequency.Weekly.
    public var byweekday: [EKWeekday]?

    /// The hours of the day associated with the recurrence rule, as an array of integers. Values can be from 1 to 24.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific hours of the day and a frequency type of RecurrenceFrequency.Day
    public var byhour: [Int]?

    /// The minutes of the hour associated with the recurrence rule, as an array of integers. Values can be from 1 to 60.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific minutes of the hour and a frequency type of RecurrenceFrequency.Hour.
    public var byminute: [Int]?

    /// The seconds of the minute associated with the recurrence rule, as an array of integers. Values can be from 1 to 60.
    ///
    /// This property value is valid only for recurrence rules that were initialized with specific seconds of the minute and a frequency type of RecurrenceFrequency.Minute.
    public var bysecond: [Int]?

    public func toRRuleString() -> String {
        return RRule.stringFromRule(self)
    }

    public static func ruleWithString(rruleString: String) -> RecurrenceRule? {
        return RRule.ruleFormString(rruleString)
    }
}

extension RecurrenceRule {
    public func occurrencesBetween(date startDate: NSDate, andDate endDate: NSDate) -> [NSDate] {
        return []
    }
}
