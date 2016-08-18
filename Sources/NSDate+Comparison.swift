//
//  NSDate+Comparison.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

internal extension NSDate {
    internal func isBefore(date: NSDate) -> Bool {
        return compare(date) == .OrderedAscending
    }

    internal func isSameWith(date: NSDate) -> Bool {
        return compare(date) == .OrderedSame
    }

    internal func isAfter(date: NSDate) -> Bool {
        return compare(date) == .OrderedDescending
    }

    internal func isBeforeOrSameWith(date: NSDate) -> Bool {
        return isBefore(date) || isSameWith(date)
    }

    internal func isAfterOrSameWith(date: NSDate) -> Bool {
        return isAfter(date) || isSameWith(date)
    }
}
