//
//  SLDatePickerView.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLDatePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    private var textFontColor: UIColor = .black
    private var hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    private var minutes = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
    private var modifiers = ["am", "pm"]
    private var titles: [[String]] = []
    private(set) var date: Date = Date() {
        didSet {
            print("\(hoursFromNow) hours and \(minutesFromNow) minutes from now")
        }
    }
    let calendar = Calendar.current
    
    var hoursFromNow: Int {
        let hours = calendar.dateComponents([.hour], from: Date(), to: date).hour!
        return hours
    }
    var minutesFromNow: Int {
        let newDate = calendar.date(byAdding: .hour, value: hoursFromNow, to: Date())!
        let minutes = calendar.dateComponents([.minute], from: newDate, to: date).minute!
        return minutes
    }

    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        dataSource = self
        delegate = self
        titles = [hours, minutes, modifiers]
        date = dateFromComponents()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        dataSource = self
        delegate = self
        titles = [hours, minutes, modifiers]
        date = dateFromComponents()
    }
    
    // MARK: - Public API
    func setDateTo(_ value: Int, component: Calendar.Component, from date: Date = Date()) {
        let date = calendar.date(byAdding: component, value: value, to: date)!
        componentsToDate(date)
    }
    
    // MARK: - Picker View Data Source
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
    
    // MARK: - Picker View Delegate
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleString = titles[component][row]
        let title = NSAttributedString(string: titleString, attributes: [.foregroundColor: UIColor.white])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        date = dateFromComponents()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
//        print("alarm date: \(dateFormatter.string(from: date))\ncurrent date: \(dateFormatter.string(from: Date()))")
    }
    
    // MARK: - Utility Methods
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
    
    private func componentsToDate(_ date: Date) {
        let components = calendar.dateComponents([.hour, .minute], from: date)
        guard var hour = components.hour, var minute = components.minute else { return }
        
        minute = roundMinute(minute)
        
        let modifierIndex: Int
        if hour < 12 {
            modifierIndex = 0
        } else {
            hour -= 12
            modifierIndex = 1
        }
        
        let hourString = String(hour)
        let minuteString = String(minute)
        
        guard let hourIndex = hours.index(of: hourString), let minuteIndex = minutes.index(of: minuteString) else { return }
        
        selectRow(hourIndex, inComponent: 0, animated: true)
        selectRow(minuteIndex, inComponent: 1, animated: true)
        selectRow(modifierIndex, inComponent: 2, animated: true)
        self.date = dateFromComponents()
    }
    
    private func roundMinute(_ minute: Int) -> Int {
        if minute % 5 == 0 {
            return minute
        } else {
            return minute + (5 - minute % 5)
        }
    }
}
