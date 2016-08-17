//
//  EKWeekday+RRule.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import EventKit

internal extension EKWeekday {
    internal func toSymbol() -> String {
        switch self {
        case .Monday: return "MO"
        case .Tuesday: return "TU"
        case .Wednesday: return "WE"
        case .Thursday: return "TH"
        case .Friday: return "FR"
        case .Saturday: return "SA"
        case .Sunday: return "SU"
        }
    }

    internal func toNumberSymbol() -> Int {
        switch self {
        case .Monday: return 0
        case .Tuesday: return 1
        case .Wednesday: return 2
        case .Thursday: return 3
        case .Friday: return 4
        case .Saturday: return 5
        case .Sunday: return 6
        }
    }

    internal static func weekdayFromSymbol(symbol: String) -> EKWeekday? {
        switch symbol {
        case "MO", "0": return EKWeekday.Monday
        case "TU", "1": return EKWeekday.Tuesday
        case "WE", "2": return EKWeekday.Wednesday
        case "TH", "3": return EKWeekday.Thursday
        case "FR", "4": return EKWeekday.Friday
        case "SA", "5": return EKWeekday.Saturday
        case "SU", "6": return EKWeekday.Sunday
        default: return nil
        }
    }
}

extension EKWeekday: Comparable { }

public func <(lhs: EKWeekday, rhs: EKWeekday) -> Bool {
    return lhs.toNumberSymbol() < rhs.toNumberSymbol()
}

public func ==(lhs: EKWeekday, rhs: EKWeekday) -> Bool {
    return lhs.toNumberSymbol() == rhs.toNumberSymbol()
}
