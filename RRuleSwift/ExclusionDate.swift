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
    public private(set) var dates = [NSDate]()
    /// The unit of ExclusionDate, used to decide which exdate will be excluded.
    public private(set) var unit: NSCalendarUnit!

    public init(dates: [NSDate], unitGranularity unit: NSCalendarUnit) {
        self.dates = dates
        self.unit = unit
    }

    public init?(exdateString string: String, unitGranularity unit: NSCalendarUnit) {
        let string = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        guard let range = string.rangeOfString("EXDATE:") where range.startIndex == string.startIndex else {
            print("error: invalid exdate string, must be started with 'EXDATE:'")
            return nil
        }
        let exdateString = string.substringFromIndex(range.endIndex)
        let exdates = exdateString.componentsSeparatedByString(",").flatMap { (dateString) -> String? in
            if (dateString.isEmpty || dateString.characters.count == 0) {
                return nil
            }
            return dateString
        }

        self.dates = exdates.flatMap({ (dateString) -> NSDate? in
            return RRule.dateFormatter.dateFromString(dateString)
        })
        self.unit = unit
    }

    public func toExDateString() -> String {
        var exdateString = "EXDATE:"
        let dateStrings = dates.map { (date) -> String in
            return RRule.dateFormatter.stringFromDate(date)
        }
        if dateStrings.count > 0 {
            exdateString += dateStrings.joinWithSeparator(",")
        }

        if exdateString.substringFromIndex(exdateString.endIndex.advancedBy(-1)) == "," {
            exdateString.removeAtIndex(exdateString.endIndex.advancedBy(-1))
        }

        return exdateString
    }
}
