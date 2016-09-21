//
//  NSDate+Comparison.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

internal extension Date {
    internal func isBefore(_ date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }

    internal func isSame(with date: Date) -> Bool {
        return compare(date) == .orderedSame
    }

    internal func isAfter(_ date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }

    internal func isBeforeOrSame(with date: Date) -> Bool {
        return isBefore(date) || isSame(with: date)
    }

    internal func isAfterOrSame(with date: Date) -> Bool {
        return isAfter(date) || isSame(with: date)
    }
}
