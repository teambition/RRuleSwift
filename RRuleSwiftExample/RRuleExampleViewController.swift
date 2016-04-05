//
//  RRuleExampleViewController.swift
//  RRuleSwiftExample
//
//  Created by 洪鑫 on 16/3/28.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit
import EventKit
import RRuleSwift

private let kFrequencies = ["Yearly", "Monthly", "Weekly", "Daily", "Hourly", "Minutely", "Secondly"]
private let kFrequencyStrings = ["YEARLY", "MONTHLY", "WEEKLY", "DAILY", "HOURLY", "MINUTELY", "SECONDLY"]
private let kFrequenciesDic: [String: RecurrenceFrequency] = ["Yearly": .Yearly, "Monthly": .Monthly, "Weekly": .Weekly, "Daily": .Daily, "Hourly": .Hourly, "Minutely": .Minutely, "Secondly": .Secondly]
private let kWeekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
private let kWeekdaysDic: [String: EKWeekday] = ["Monday": .Monday, "Tuesday": .Tuesday, "Wednesday": .Wednesday, "Thursday": .Thursday, "Friday": .Friday, "Saturday": .Saturday, "Sunday": .Sunday]
private let kEKWeekdays: [EKWeekday] = [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday]
private let kMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

extension RecurrenceFrequency {
    func toString() -> String {
        switch self {
        case .Secondly: return "SECONDLY"
        case .Minutely: return "MINUTELY"
        case .Hourly: return "HOURLY"
        case .Daily: return "DAILY"
        case .Weekly: return "WEEKLY"
        case .Monthly: return "MONTHLY"
        case .Yearly: return "YEARLY"
        }
    }
}

extension EKWeekday {
    func toNumberSymbol() -> Int {
        switch self {
        case .Monday: return 0
        case .Tuesday: return 1
        case .Wednesday: return 2
        case .Thursday: return 3
        case .Friday: return 4
        case .Saturday: return 5
        case .Sunday: return 6
        }
    }
}

class RRuleExampleViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    private var rule = RecurrenceRule() {
        didSet {
            textView.text = rule.toRRuleString()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "RRuleSwift Example"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        rule = RecurrenceRule()
        textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .Plain, target: self, action: #selector(resetButtonTapped(_:)))
    }

    func resetButtonTapped(sender: UIBarButtonItem) {
        rule = RecurrenceRule()
    }
}

extension RRuleExampleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 9
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 3: return 1
        case 4: return 1
        case 5: return 1
        case 6: return 7
        case 7: return 12
        case 8: return 31
        default: return 0
        }
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Frequency"
        case 1: return "Interval"
        case 2: return "First Day Of Week"
        case 3: return "Start Date"
        case 4: return "End Date"
        case 5: return "Occurrence Count"
        case 6: return "byweekday"
        case 7: return "bymonth"
        case 8: return "bymonthday"
        default: return nil
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, _): return kPickerViewCellHeight
        case (1, _): return kPickerViewCellHeight
        case (2, _): return kPickerViewCellHeight
        case (3, _): return kDatePickerCellHeight
        case (4, _): return kDatePickerCellHeight
        case (5, _): return kPickerViewCellHeight
        default: return 36
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(kPickerViewCellID, forIndexPath: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            if let frequency = rule.frequency {
                cell.pickerView.selectRow(kFrequencyStrings.indexOf(frequency.toString()) ?? 0, inComponent: 0, animated: true)
            } else {
                cell.pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            return cell
        case (1, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(kPickerViewCellID, forIndexPath: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            cell.pickerView.selectRow(rule.interval - 1, inComponent: 0, animated: true)
            return cell
        case (2, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(kPickerViewCellID, forIndexPath: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            cell.pickerView.selectRow(rule.firstDayOfWeek.toNumberSymbol(), inComponent: 0, animated: true)
            return cell
        case (3, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(kDatePickerCellID, forIndexPath: indexPath) as! DatePickerCell
            cell.datePicker.date = rule.startDate
            cell.datePicker.addTarget(self, action: #selector(startDateDidChange(_:)), forControlEvents: .ValueChanged)
            return cell
        case (4, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(kDatePickerCellID, forIndexPath: indexPath) as! DatePickerCell
            cell.datePicker.date = rule.recurrenceEnd?.endDate ?? NSDate()
            cell.datePicker.addTarget(self, action: #selector(endDateDidChange(_:)), forControlEvents: .ValueChanged)
            return cell
        case (5, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(kPickerViewCellID, forIndexPath: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            if rule.recurrenceEnd?.endDate == nil {
                cell.pickerView.selectRow((rule.recurrenceEnd?.occurrenceCount ?? 1) - 1, inComponent: 0, animated: true)
            } else {
                cell.pickerView.selectRow(0, inComponent: 0, animated: true)
            }
            return cell
        case (6, _):
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            }
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            cell?.textLabel?.text = kWeekdays[indexPath.row]
            let byweekday = rule.byweekday ?? []
            let weekdays = byweekday.map({ (weekday) -> NSIndexPath in
                return NSIndexPath(forRow: weekday.toNumberSymbol(), inSection: 6)
            })
            if weekdays.contains(indexPath) {
                cell?.accessoryType = .Checkmark
            } else {
                cell?.accessoryType = .None
            }
            return cell!
        case (7, _):
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            }
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            cell?.textLabel?.text = kMonths[indexPath.row]
            let bymonths = rule.bymonth ?? []
            let months = bymonths.map({ (month) -> NSIndexPath in
                return NSIndexPath(forRow: month - 1, inSection: 7)
            })
            if months.contains(indexPath) {
                cell?.accessoryType = .Checkmark
            } else {
                cell?.accessoryType = .None
            }
            return cell!
        case (8, _):
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            }
            cell?.selectionStyle = .None
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            cell?.textLabel?.text = String(indexPath.row + 1)
            let bymonthday = rule.bymonthday ?? []
            let monthdays = bymonthday.map({ (month) -> NSIndexPath in
                return NSIndexPath(forRow: month - 1, inSection: 8)
            })
            if monthdays.contains(indexPath) {
                cell?.accessoryType = .Checkmark
            } else {
                cell?.accessoryType = .None
            }
            return cell!
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
            }
            cell?.textLabel?.font = UIFont.systemFontOfSize(15)
            return cell!
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (6, _):
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let byweekday = rule.byweekday ?? []
            var weekdays = byweekday.map({ (weekday) -> NSIndexPath in
                return NSIndexPath(forRow: weekday.toNumberSymbol(), inSection: 6)
            })
            if weekdays.contains(indexPath) {
                cell?.accessoryType = .None
                weekdays.removeAtIndex(weekdays.indexOf(indexPath)!)
                rule.byweekday = weekdays.map({ (indexPath) -> EKWeekday in
                    return kEKWeekdays[indexPath.row]
                }).sort(<)
            } else {
                cell?.accessoryType = .Checkmark
                weekdays.append(indexPath)
                rule.byweekday = weekdays.map({ (indexPath) -> EKWeekday in
                    return kEKWeekdays[indexPath.row]
                }).sort(<)
            }
        case (7, _):
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let bymonths = rule.bymonth ?? []
            var months = bymonths.map({ (month) -> NSIndexPath in
                return NSIndexPath(forRow: month - 1, inSection: 7)
            })
            if months.contains(indexPath) {
                cell?.accessoryType = .None
                months.removeAtIndex(months.indexOf(indexPath)!)
                rule.bymonth = months.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sort(<)
            } else {
                cell?.accessoryType = .Checkmark
                months.append(indexPath)
                rule.bymonth = months.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sort(<)
            }
        case (8, _):
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let bymonthday = rule.bymonthday ?? []
            var monthdays = bymonthday.map({ (month) -> NSIndexPath in
                return NSIndexPath(forRow: month - 1, inSection: 8)
            })
            if monthdays.contains(indexPath) {
                cell?.accessoryType = .None
                monthdays.removeAtIndex(monthdays.indexOf(indexPath)!)
                rule.bymonthday = monthdays.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sort(<)
            } else {
                cell?.accessoryType = .Checkmark
                monthdays.append(indexPath)
                rule.bymonthday = monthdays.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sort(<)
            }
        default:
            break
        }
    }
}

extension RRuleExampleViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 5: return 1
        default: return 1
        }
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0: return kFrequencies.count
        case 1: return 999
        case 2: return kWeekdays.count
        case 5: return 999
        default: return 0
        }
    }

    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return kFrequencies[row]
        case 1:
            return String(row + 1)
        case 2:
            return kWeekdays[row]
        case 5:
            return String(row + 1)
        default: return nil
        }
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            rule.frequency = kFrequenciesDic[kFrequencies[row]]
        case 1:
            rule.interval = row + 1
        case 2:
            rule.firstDayOfWeek = kEKWeekdays[row]
        case 5:
            rule.recurrenceEnd = EKRecurrenceEnd(occurrenceCount: row + 1)
        default: break
        }
    }
}

extension RRuleExampleViewController {
    func startDateDidChange(datePicker: UIDatePicker) {
        rule.startDate = datePicker.date
    }

    func endDateDidChange(datePicker: UIDatePicker) {
        rule.recurrenceEnd = EKRecurrenceEnd(endDate: datePicker.date)
    }
}

extension RRuleExampleViewController: UITextViewDelegate {
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if !textView.hasText() && text == "" {
            return false
        }

        if text == "\n" {
            textView.resignFirstResponder()
            rule = RecurrenceRule.ruleWithString(textView.text) ?? RecurrenceRule()
            return false
        }
        return true
    }
}
