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
    public var calendar = Calendar.current

    /// The frequency of the recurrence rule.
    public var frequency: RecurrenceFrequency

    /// Specifies how often the recurrence rule repeats over the component of time indicated by its frequency. For example, a recurrence rule with a frequency type of RecurrenceFrequency.weekly and an interval of 2 repeats every two weeks.
    ///
    /// The default value of this property is 1.
    public var interval = 1

    /// Indicates which day of the week the recurrence rule treats as the first day of the week. 
    ///
    /// The default value of this property is EKWeekday.monday.
    public var firstDayOfWeek: EKWeekday = .monday

    /// The start date of recurrence rule.
    ///
    /// The default value of this property is current date.
    public var startDate = Date()

    /// Indicates when the recurrence rule ends. This can be represented by an end date or a number of occurrences.
    public var recurrenceEnd: EKRecurrenceEnd?

    /// An array of ordinal integers that filters which recurrences to include in the recurrence rule’s frequency. Values can be from 1 to 366 and from -1 to -366.
    ///
    /// For example, if a bysetpos of -1 is combined with a RecurrenceFrequency.monthly frequency, and a byweekday of (EKWeekday.monday, EKWeekday.tuesday, EKWeekday.wednesday, EKWeekday.thursday, EKWeekday.friday), will result in the last work day of every month.
    ///
    /// Negative values indicate counting backwards from the end of the recurrence rule’s frequency.
    public var bysetpos = [Int]()

    /// The days of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 366 and from -1 to -366.
    ///
    /// Negative values indicate counting backwards from the end of the year.
    public var byyearday = [Int]()

    /// The months of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 12.
    public var bymonth = [Int]()

    /// The weeks of the year associated with the recurrence rule, as an array of integers. Values can be from 1 to 53 and from -1 to -53. According to ISO8601, the first week of the year is that containing at least four days of the new year.
    ///
    /// Negative values indicate counting backwards from the end of the year.
    public var byweekno = [Int]()

    /// The days of the month associated with the recurrence rule, as an array of integers. Values can be from 1 to 31 and from -1 to -31.
    ///
    /// Negative values indicate counting backwards from the end of the month.
    public var bymonthday = [Int]()

    /// The days of the week associated with the recurrence rule, as an array of EKWeekday objects.
    public var byweekday = [EKWeekday]()

    /// The hours of the day associated with the recurrence rule, as an array of integers.
    public var byhour = [Int]()

    /// The minutes of the hour associated with the recurrence rule, as an array of integers.
    public var byminute = [Int]()

    /// The seconds of the minute associated with the recurrence rule, as an array of integers.
    public var bysecond = [Int]()

    /// The inclusive dates of the recurrence rule.
    public var rdate: InclusionDate?

    /// The exclusion dates of the recurrence rule. The dates of this property will not be generated, even if some inclusive rdate matches the recurrence rule.
    public var exdate: ExclusionDate?

    public init(frequency: RecurrenceFrequency) {
        self.frequency = frequency
    }

    public init?(rruleString: String) {
        if let recurrenceRule = RRule.ruleFromString(rruleString) {
            self = recurrenceRule
        } else {
            return nil
        }
    }

    public func toRRuleString() -> String {
        return RRule.stringFromRule(self)
    }
}
