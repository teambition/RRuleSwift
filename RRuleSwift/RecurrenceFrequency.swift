//
//  RecurrenceFrequency.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

public enum RecurrenceFrequency {
    case Yearly
    case Monthly
    case Weekly
    case Daily
    case Hourly
    case Minutely
    case Secondly

    internal func toString() -> String {
        switch self {
        case .Secondly: return "SECONDLY"
        case .Minutely: return "MINUTELY"
        case .Hourly: return "HOURLY"
        case .Daily: return "DAILY"
        case .Weekly: return "WEEKLY"
        case .Monthly: return "MONTHLY"
        case .Yearly: return "YEARLY"
        }
    }

    internal static func frequencyFromString(string: String) -> RecurrenceFrequency? {
        switch string {
        case "SECONDLY": return .Secondly
        case "MINUTELY": return .Minutely
        case "HOURLY": return .Hourly
        case "DAILY": return .Daily
        case "WEEKLY": return .Weekly
        case "MONTHLY": return .Monthly
        case "YEARLY": return .Yearly
        default: return nil
        }
    }
}
