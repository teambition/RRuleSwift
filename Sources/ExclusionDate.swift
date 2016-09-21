//
//  ExclusionDate.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

public struct ExclusionDate {
    /// All exclusion dates.
    public fileprivate(set) var dates = [Date]()
    /// The component of ExclusionDate, used to decide which exdate will be excluded.
    public fileprivate(set) var component: Calendar.Component!

    public init(dates: [Date], granularity component: Calendar.Component) {
        self.dates = dates
        self.component = component
    }

    public init?(exdateString string: String, granularity component: Calendar.Component) {
        let string = string.trimmingCharacters(in: .whitespaces)
        guard let range = string.range(of: "EXDATE:"), range.lowerBound == string.startIndex else {
            return nil
        }
        let exdateString = string.substring(from: range.upperBound)
        let exdates = exdateString.components(separatedBy: ",").flatMap { (dateString) -> String? in
            if (dateString.isEmpty || dateString.characters.count == 0) {
                return nil
            }
            return dateString
        }

        self.dates = exdates.flatMap({ (dateString) -> Date? in
            return RRule.dateFormatter.date(from: dateString)
        })
        self.component = component
    }

    public func toExDateString() -> String {
        var exdateString = "EXDATE:"
        let dateStrings = dates.map { (date) -> String in
            return RRule.dateFormatter.string(from: date)
        }
        if dateStrings.count > 0 {
            exdateString += dateStrings.joined(separator: ",")
        }

        if exdateString.substring(from: exdateString.characters.index(exdateString.endIndex, offsetBy: -1)) == "," {
            exdateString.remove(at: exdateString.characters.index(exdateString.endIndex, offsetBy: -1))
        }

        return exdateString
    }
}
