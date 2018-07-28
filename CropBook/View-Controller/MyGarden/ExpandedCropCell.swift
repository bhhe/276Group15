//
//  ExpandedCropCell.swift
//  CropBook
//
//  Created by jon on 2018-07-24.
//  Copyright © 2018 CMPT276-Group15. All rights reserved.
//

import UIKit
import MultiSelectSegmentedControl

class ExpandedCropCell: UITableViewCell {

    @IBOutlet weak var setReminder: UILabel!
    @IBOutlet weak var enableReminder: UISwitch!
    @IBOutlet weak var selectDays: MultiSelectSegmentedControl!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var waterAmount: UILabel!
    @IBOutlet weak var plotSize: UITextField!
    
    private var timePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        timePicker = UIDatePicker()
        timePicker?.datePickerMode = .time
        timePicker?.minuteInterval = 5
        timePicker?.addTarget(self, action: #selector(ExpandedCropCell.timeChanged(timePicker:)) , for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ExpandedCropCell.viewTapped(gestureRecognizer:)))
        self.addGestureRecognizer(tapGesture)
        
        
        timeField.inputView = timePicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        self.endEditing(true)
    }

    @objc func timeChanged(timePicker: UIDatePicker){

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        timeField.text = timeFormatter.string(from: timePicker.date)
        
        timeField.resignFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
