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
private let kFrequenciesDic: [String: RecurrenceFrequency] = ["Yearly": .yearly, "Monthly": .monthly, "Weekly": .weekly, "Daily": .daily, "Hourly": .hourly, "Minutely": .minutely, "Secondly": .secondly]
private let kWeekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
private let kWeekdaysDic: [String: EKWeekday] = ["Monday": .monday, "Tuesday": .tuesday, "Wednesday": .wednesday, "Thursday": .thursday, "Friday": .friday, "Saturday": .saturday, "Sunday": .sunday]
private let kEKWeekdays: [EKWeekday] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
private let kMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

extension RecurrenceFrequency {
    func toString() -> String {
        switch self {
        case .secondly: return "SECONDLY"
        case .minutely: return "MINUTELY"
        case .hourly: return "HOURLY"
        case .daily: return "DAILY"
        case .weekly: return "WEEKLY"
        case .monthly: return "MONTHLY"
        case .yearly: return "YEARLY"
        }
    }
}

extension EKWeekday {
    func toNumberSymbol() -> Int {
        switch self {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }
}

class RRuleExampleViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var tableView: UITableView!

    fileprivate var rule = RecurrenceRule(frequency: .daily) {
        didSet {
            textView.text = rule.toRRuleString()
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        testRRuleIterator()
    }

    fileprivate func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.title = "RRuleSwift Example"
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        rule = RecurrenceRule(frequency: .daily)
        textView.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetButtonTapped(_:)))
    }

    fileprivate func testRRuleIterator() {
        let dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEE"
            return dateFormatter
        }()

        var rule = RecurrenceRule(rruleString: "RRULE:FREQ=WEEKLY;DTSTART=20151119T014500Z;INTERVAL=1;BYDAY=MO,TU,WE,TH,FR;UNTIL=20170101T014500Z")!
        rule.exdate = ExclusionDate(exdateString: "EXDATE:20151120T014500Z,20151123T014500Z,20151126T014500Z,20151127T014500Z,20151130T014500Z,20151201T014500Z,20151202T014500Z,20151203T014500Z,20151207T014500Z,20151210T014500Z,20151211T014500Z,20151215T014500Z,20151216T014500Z,20151217T014500Z,20151221T014500Z,20151222T014500Z,20151223T014500Z,20151228T014500Z,20151229T014500Z", granularity: .day)
        let date =  dateFormatter.date(from: "2015-11-01 00:00:00 Sun")!
        let otherDate =  dateFormatter.date(from: "2016-02-01 00:00:00 Sun")!

        let occurrences = rule.occurrences(between: date, and: otherDate)

        print("\nRRule Occurrences:")
        occurrences.forEach { (occurrence) in
            print(dateFormatter.string(from: occurrence))
        }
        print("\n")
    }

    @objc func resetButtonTapped(_ sender: UIBarButtonItem) {
        rule = RecurrenceRule(frequency: .daily)
    }
}

extension RRuleExampleViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: kPickerViewCellID, for: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            cell.pickerView.selectRow(kFrequencyStrings.index(of: rule.frequency.toString()) ?? 0, inComponent: 0, animated: true)
            return cell
        case (1, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: kPickerViewCellID, for: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            cell.pickerView.selectRow(rule.interval - 1, inComponent: 0, animated: true)
            return cell
        case (2, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: kPickerViewCellID, for: indexPath) as! PickerViewCell
            cell.pickerView.tag = indexPath.section
            cell.pickerView.dataSource = self
            cell.pickerView.delegate = self
            cell.pickerView.selectRow(rule.firstDayOfWeek.toNumberSymbol(), inComponent: 0, animated: true)
            return cell
        case (3, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: kDatePickerCellID, for: indexPath) as! DatePickerCell
            cell.datePicker.date = rule.startDate
            cell.datePicker.addTarget(self, action: #selector(startDateDidChange(_:)), for: .valueChanged)
            return cell
        case (4, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: kDatePickerCellID, for: indexPath) as! DatePickerCell
            cell.datePicker.date = rule.recurrenceEnd?.endDate ?? Date()
            cell.datePicker.addTarget(self, action: #selector(endDateDidChange(_:)), for: .valueChanged)
            return cell
        case (5, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: kPickerViewCellID, for: indexPath) as! PickerViewCell
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
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            }
            cell?.selectionStyle = .none
            cell?.textLabel?.font = .systemFont(ofSize: 15)
            cell?.textLabel?.text = kWeekdays[indexPath.row]
            let weekdays = rule.byweekday.map({ (weekday) -> IndexPath in
                return IndexPath(row: weekday.toNumberSymbol(), section: 6)
            })
            if weekdays.contains(indexPath) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            return cell!
        case (7, _):
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            }
            cell?.selectionStyle = .none
            cell?.textLabel?.font = .systemFont(ofSize: 15)
            cell?.textLabel?.text = kMonths[indexPath.row]
            let months = rule.bymonth.map({ (month) -> IndexPath in
                return IndexPath(row: month - 1, section: 7)
            })
            if months.contains(indexPath) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            return cell!
        case (8, _):
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            }
            cell?.selectionStyle = .none
            cell?.textLabel?.font = .systemFont(ofSize: 15)
            cell?.textLabel?.text = String(indexPath.row + 1)
            let monthdays = rule.bymonthday.map({ (month) -> IndexPath in
                return IndexPath(row: month - 1, section: 8)
            })
            if monthdays.contains(indexPath) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            return cell!
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
            if cell == nil {
                cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            }
            cell?.textLabel?.font = .systemFont(ofSize: 15)
            return cell!
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (6, _):
            let cell = tableView.cellForRow(at: indexPath)
            var weekdays = rule.byweekday.map({ (weekday) -> IndexPath in
                return IndexPath(row: weekday.toNumberSymbol(), section: 6)
            })
            if weekdays.contains(indexPath) {
                cell?.accessoryType = .none
                weekdays.remove(at: weekdays.index(of: indexPath)!)
                rule.byweekday = weekdays.map({ (indexPath) -> EKWeekday in
                    return kEKWeekdays[indexPath.row]
                }).sorted(by: <)
            } else {
                cell?.accessoryType = .checkmark
                weekdays.append(indexPath)
                rule.byweekday = weekdays.map({ (indexPath) -> EKWeekday in
                    return kEKWeekdays[indexPath.row]
                }).sorted(by: <)
            }
        case (7, _):
            let cell = tableView.cellForRow(at: indexPath)
            var months = rule.bymonth.map({ (month) -> IndexPath in
                return IndexPath(row: month - 1, section: 7)
            })
            if months.contains(indexPath) {
                cell?.accessoryType = .none
                months.remove(at: months.index(of: indexPath)!)
                rule.bymonth = months.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sorted(by: <)
            } else {
                cell?.accessoryType = .checkmark
                months.append(indexPath)
                rule.bymonth = months.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sorted(by: <)
            }
        case (8, _):
            let cell = tableView.cellForRow(at: indexPath)
            var monthdays = rule.bymonthday.map({ (month) -> IndexPath in
                return IndexPath(row: month - 1, section: 8)
            })
            if monthdays.contains(indexPath) {
                cell?.accessoryType = .none
                monthdays.remove(at: monthdays.index(of: indexPath)!)
                rule.bymonthday = monthdays.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sorted(by: <)
            } else {
                cell?.accessoryType = .checkmark
                monthdays.append(indexPath)
                rule.bymonthday = monthdays.map({ (indexPath) -> Int in
                    return indexPath.row + 1
                }).sorted(by: <)
            }
        default:
            break
        }
    }
}

extension RRuleExampleViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 0: return 1
        case 1: return 1
        case 2: return 1
        case 5: return 1
        default: return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0: return kFrequencies.count
        case 1: return 999
        case 2: return kWeekdays.count
        case 5: return 999
        default: return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            rule.frequency = kFrequenciesDic[kFrequencies[row]]!
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
    @objc func startDateDidChange(_ datePicker: UIDatePicker) {
        rule.startDate = datePicker.date
    }

    @objc func endDateDidChange(_ datePicker: UIDatePicker) {
        rule.recurrenceEnd = EKRecurrenceEnd(end: datePicker.date)
    }
}

extension RRuleExampleViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !textView.hasText && text == "" {
            return false
        }

        if text == "\n" {
            textView.resignFirstResponder()
            rule = RecurrenceRule(rruleString: textView.text) ?? RecurrenceRule(frequency: .daily)
            return false
        }
        return true
    }
}
