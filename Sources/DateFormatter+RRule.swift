//
//  DateFormatter+RRule.swift
//  RRuleSwift-iOS
//
//  Created by Sunny Chan on 6/19/18.
//  Copyright © 2018 Teambition. All rights reserved.
//

import Foundation

extension DateFormatter {
	convenience init(_ dateFormat: String, _ timeZone: TimeZone? = nil, _ safely: Bool = true) {
		self.init()
		self.dateFormat = dateFormat
		
		if timeZone == nil {
			self.timeZone = TimeZone(secondsFromGMT: 0)
		}
		
		if safely {
			// NOTE: AM/PM on 12/24 hour switch is broken on some locale.
			// https://stackoverflow.com/a/6735644
			// https://github.com/teambition/RRuleSwift/issues/12
			self.locale = Locale(identifier: "en_US_POSIX")
		}
	}
}
