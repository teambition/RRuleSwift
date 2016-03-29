//
//  DatePickerCell.swift
//  RRuleSwiftExample
//
//  Created by 洪鑫 on 16/3/29.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

let kDatePickerCellID = "DatePickerCell"
let kDatePickerCellHeight: CGFloat = 110

class DatePickerCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
