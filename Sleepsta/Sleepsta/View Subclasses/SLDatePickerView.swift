//
//  SLDatePickerView.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLDatePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var textFontColor: UIColor = .black
    private var hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    private var minutes = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
    private var modifiers = ["am", "pm"]
    private var titles: [[String]] = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataSource = self
        delegate = self
        titles = [hours, minutes, modifiers]
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        dataSource = self
        delegate = self
        titles = [hours, minutes, modifiers]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return hours.count
        case 1:
            return minutes.count
        case 2:
            return modifiers.count
        default:
            fatalError("What happened? There should only be three components")
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleString = titles[component][row]
        let title = NSAttributedString(string: titleString, attributes: [.foregroundColor: UIColor.white])
        return title
    }
}
