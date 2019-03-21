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
    private(set) var date: Date = Date()
    let calendar = Calendar.current

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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        date = dateFromComponents()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        print("alarm date: \(dateFormatter.string(from: date))\ncurrent date: \(dateFormatter.string(from: Date()))")
    }
    
    private func dateFromComponents() -> Date {
        // Get the current componenets, and adjust based on modifier
        var hour = Int(hours[selectedRow(inComponent: 0)])!
        if hour == 12 { hour -= 12 }
        let minute = Int(minutes[selectedRow(inComponent: 1)])!
        let modifier = modifiers[selectedRow(inComponent: 2)]
        if modifier == "pm" { hour += 12 }
        
        // Grab the components from the current date and set the hour and minute
        var components = calendar.dateComponents([.day, .year, .month, .calendar, .era, .timeZone], from: Date())
        components.hour = hour
        components.minute = minute
        
        // Make a date from the components and add a day if it is before the current time
        var date = calendar.date(from: components)!
        let comparison = calendar.compare(date, to: Date(), toGranularity: .minute)
        if comparison == .orderedAscending {
            date = calendar.date(byAdding: .day, value: 1, to: date)!
        }
        
        return date
    }
}
