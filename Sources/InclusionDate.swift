//
//  InclusionDate.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public struct InclusionDate {
    /// All inclusive dates.
    public fileprivate(set) var dates = [Date]()

    public init(dates: [Date]) {
        self.dates = dates
    }

    public init?(rdateString string: String) {
        let string = string.trimmingCharacters(in: .whitespaces)
        guard let range = string.range(of: "RDATE:"), range.lowerBound == string.startIndex else {
            return nil
        }
        let rdateString = String(string.suffix(from: range.upperBound))
        let rdates = rdateString.components(separatedBy: ",").compactMap { (dateString) -> String? in
            if dateString.isEmpty {
                return nil
            }
            return dateString
        }

        self.dates = rdates.compactMap({ (dateString) -> Date? in
            if let date = RRule.dateFormatter.date(from: dateString) {
                return date
            } else if let date = RRule.realDate(dateString) {
                return date
            }
            return nil
        })
    }

    public func toRDateString() -> String {
        var rdateString = "RDATE:"
        let dateStrings = dates.map { (date) -> String in
            return RRule.dateFormatter.string(from: date)
        }
        if dateStrings.count > 0 {
            rdateString += dateStrings.joined(separator: ",")
        }

        if String(rdateString.suffix(from: rdateString.index(rdateString.endIndex, offsetBy: -1))) == "," {
            rdateString.remove(at: rdateString.index(rdateString.endIndex, offsetBy: -1))
        }

        return rdateString
    }
}
