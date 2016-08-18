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
    public private(set) var dates = [NSDate]()

    public init(dates: [NSDate]) {
        self.dates = dates
    }

    public init?(rdateString string: String) {
        let string = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        guard let range = string.rangeOfString("RDATE:") where range.startIndex == string.startIndex else {
//            print("error: invalid rdate string, must be started with 'RDATE:'")
            return nil
        }
        let rdateString = string.substringFromIndex(range.endIndex)
        let rdates = rdateString.componentsSeparatedByString(",").flatMap { (dateString) -> String? in
            if (dateString.isEmpty || dateString.characters.count == 0) {
                return nil
            }
            return dateString
        }

        self.dates = rdates.flatMap({ (dateString) -> NSDate? in
            return RRule.dateFormatter.dateFromString(dateString)
        })
    }

    public func toRDateString() -> String {
        var rdateString = "RDATE:"
        let dateStrings = dates.map { (date) -> String in
            return RRule.dateFormatter.stringFromDate(date)
        }
        if dateStrings.count > 0 {
            rdateString += dateStrings.joinWithSeparator(",")
        }

        if rdateString.substringFromIndex(rdateString.endIndex.advancedBy(-1)) == "," {
            rdateString.removeAtIndex(rdateString.endIndex.advancedBy(-1))
        }

        return rdateString
    }
}
