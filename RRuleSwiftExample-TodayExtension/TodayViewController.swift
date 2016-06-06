//
//  TodayViewController.swift
//  RRuleSwiftExample-TodayExtension
//
//  Created by 洪鑫 on 16/6/6.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import NotificationCenter
import RRuleSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone.defaultTimeZone()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
        return dateFormatter
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        var rule = RecurrenceRule(recurrenceWithRRuleString: "RRULE:FREQ=WEEKLY;DTSTART=20151119T014500Z;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR;UNTIL=20170101T014500Z")!
        rule.exdate = ExclusionDate(exdateString: "EXDATE:20151120T014500Z,20151123T014500Z,20151126T014500Z,20151127T014500Z,20151130T014500Z,20151201T014500Z,20151202T014500Z,20151203T014500Z,20151207T014500Z,20151210T014500Z,20151211T014500Z,20151215T014500Z,20151216T014500Z,20151217T014500Z,20151221T014500Z,20151222T014500Z,20151223T014500Z,20151228T014500Z,20151229T014500Z", unitGranularity: .Day)
        let date1 =  dateFormatter.dateFromString("2016-06-06 00:00:00 Sun")!
        let date2 =  dateFormatter.dateFromString("2016-12-13 00:00:00 Sun")!

        let occurrences1 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences2 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences3 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences4 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences5 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences6 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences7 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences8 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences9 = rule.occurrencesBetween(date: date1, andDate: date2)
        let occurrences10 = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)
        let _ = rule.occurrencesBetween(date: date1, andDate: date2)

        print(occurrences1)
        print(occurrences2)
        print(occurrences3)
        print(occurrences4)
        print(occurrences5)
        print(occurrences6)
        print(occurrences7)
        print(occurrences8)
        print(occurrences9)
        print(occurrences10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
}
