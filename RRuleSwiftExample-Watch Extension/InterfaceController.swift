//
//  InterfaceController.swift
//  RRuleSwiftExample-Watch Extension
//
//  Created by DangGu on 16/8/17.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import WatchKit
import Foundation
import RRuleSwift

class InterfaceController: WKInterfaceController {
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
        return dateFormatter
    }()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let ruleString = "RRULE:FREQ=WEEKLY;DTSTART=20151119T014500Z;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR;UNTIL=20170101T014500Z"
        var rule = RecurrenceRule(rruleString: ruleString)!
        rule.exdate = ExclusionDate(exdateString: "EXDATE:20151120T014500Z,20151123T014500Z,20151126T014500Z,20151127T014500Z,20151130T014500Z,20151201T014500Z,20151202T014500Z,20151203T014500Z,20151207T014500Z,20151210T014500Z,20151211T014500Z,20151215T014500Z,20151216T014500Z,20151217T014500Z,20151221T014500Z,20151222T014500Z,20151223T014500Z,20151228T014500Z,20151229T014500Z", granularity: .day)
        let _ = rule.toRRuleString()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
