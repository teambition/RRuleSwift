//
//  NSDate+Comparison.swift
//  RRuleSwift
//
//  Created by Xin Hong on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import Foundation

internal extension Date {
    func isBefore(_ date: Date) -> Bool {
        return compare(date) == .orderedAscending
    }

    func isSame(with date: Date) -> Bool {
        return compare(date) == .orderedSame
    }

    func isAfter(_ date: Date) -> Bool {
        return compare(date) == .orderedDescending
    }

    func isBeforeOrSame(with date: Date) -> Bool {
        return isBefore(date) || isSame(with: date)
    }

    func isAfterOrSame(with date: Date) -> Bool {
        return isAfter(date) || isSame(with: date)
    }
}
