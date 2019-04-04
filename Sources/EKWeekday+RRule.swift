//
//  EKWeekday+RRule.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import EventKit

internal extension EKWeekday {
    func toSymbol() -> String {
        switch self {
        case .monday: return "MO"
        case .tuesday: return "TU"
        case .wednesday: return "WE"
        case .thursday: return "TH"
        case .friday: return "FR"
        case .saturday: return "SA"
        case .sunday: return "SU"
        }
    }

    func toNumberSymbol() -> Int {
        switch self {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }

    static func weekdayFromSymbol(_ symbol: String) -> EKWeekday? {
        switch symbol {
        case "MO", "0": return EKWeekday.monday
        case "TU", "1": return EKWeekday.tuesday
        case "WE", "2": return EKWeekday.wednesday
        case "TH", "3": return EKWeekday.thursday
        case "FR", "4": return EKWeekday.friday
        case "SA", "5": return EKWeekday.saturday
        case "SU", "6": return EKWeekday.sunday
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
