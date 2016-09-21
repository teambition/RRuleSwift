//
//  RecurrenceFrequency.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

public enum RecurrenceFrequency {
    case yearly
    case monthly
    case weekly
    case daily
    case hourly
    case minutely
    case secondly

    internal func toString() -> String {
        switch self {
        case .secondly: return "SECONDLY"
        case .minutely: return "MINUTELY"
        case .hourly: return "HOURLY"
        case .daily: return "DAILY"
        case .weekly: return "WEEKLY"
        case .monthly: return "MONTHLY"
        case .yearly: return "YEARLY"
        }
    }

    internal static func frequency(from string: String) -> RecurrenceFrequency? {
        switch string {
        case "SECONDLY": return .secondly
        case "MINUTELY": return .minutely
        case "HOURLY": return .hourly
        case "DAILY": return .daily
        case "WEEKLY": return .weekly
        case "MONTHLY": return .monthly
        case "YEARLY": return .yearly
        default: return nil
        }
    }
}
