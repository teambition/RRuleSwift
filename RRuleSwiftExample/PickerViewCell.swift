//
//  PickerViewCell.swift
//  RRuleSwiftExample
//
//  Created by 洪鑫 on 16/3/29.
//  Copyright © 2016年 Teambition. All rights reserved.
//

import UIKit

let kPickerViewCellID = "PickerViewCell"
let kPickerViewCellHeight: CGFloat = 110

class PickerViewCell: UITableViewCell {
    @IBOutlet weak var pickerView: UIPickerView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
