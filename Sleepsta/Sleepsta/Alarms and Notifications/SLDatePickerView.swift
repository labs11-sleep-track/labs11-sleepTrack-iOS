//
//  SLDatePickerView.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

protocol SLDatePickerViewDelegate: class {
    func datePicker(_ datePicker: SLDatePickerView, didChangeDate: Bool)
}

class SLDatePickerView: UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Properties
    private var textFontColor: UIColor = .black
    private var hours = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
    private var minutes = ["00", "05", "10", "15", "20", "25", "30", "35", "40", "45", "50", "55"]
    private var modifiers = ["am", "pm"]
    private var titles: [[String]] = []
    private(set) var date: Date = Date() {
        didSet {
            datePickerDelegate?.datePicker(self, didChangeDate: true)
        }
    }
    let calendar = Calendar.current
    weak var datePickerDelegate: SLDatePickerViewDelegate?
    var isEnabled: Bool = true {
        didSet {
            updateIsEnabled()
        }
    }
    
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
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if subview.bounds.height <= 1.0 {
            subview.backgroundColor = .darkBlue
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        for subview in subviews {
            if subview.bounds.height <= 1.0 {
                subview.backgroundColor = .darkBlue
            }
        }
    }
    
    // MARK: - Public API
    func setDateTo(_ value: Int, component: Calendar.Component, from date: Date = Date()) {
        let date = calendar.date(byAdding: component, value: value, to: date)!
        componentsToDate(date)
    }
    
    func setHour(to hour: Int) {
        setHourComponent(to: hour)
    }
    
    func setMinute(to minute: Int) {
        setMinuteComponent(to: minute)
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
        let title = NSAttributedString(string: titleString, attributes: [.foregroundColor: UIColor.customWhite])
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
    }
    
    // MARK: - Utility Methods
    private func dateFromComponents() -> Date {
        // Get the current components, and adjust based on modifier
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
        guard let hour = components.hour, let minute = components.minute else { return }

        setHourComponent(to: hour)
        setMinuteComponent(to: minute)
    }
    
    private func setHourComponent(to hour: Int, animated: Bool = true) {
        var hour = hour
        let modifierIndex: Int
        if hour < 12 {
            modifierIndex = 0
        } else {
            hour -= 12
            modifierIndex = 1
        }
        let hourString = String(hour)
        
        guard let hourIndex = hours.index(of: hourString) else { return }
        selectRow(hourIndex, inComponent: 0, animated: animated)
        selectRow(modifierIndex, inComponent: 2, animated: animated)
        self.date = dateFromComponents()
    }
    
    private func setMinuteComponent(to minute: Int, animated: Bool = true) {
        let minute = roundMinute(minute)
        let minuteString = String(minute)
        
        guard let minuteIndex = minutes.index(of: minuteString) else { return }
        selectRow(minuteIndex, inComponent: 1, animated: animated)
        self.date = dateFromComponents()
    }
    
    // Rounds a minute (int) up to the nearest multiple of 5
    private func roundMinute(_ minute: Int) -> Int {
        if minute % 5 == 0 {
            return minute
        } else {
            return minute + (5 - minute % 5)
        }
    }
    
    private func updateIsEnabled() {
        isUserInteractionEnabled = isEnabled
        let newAlpha: CGFloat = isEnabled ? 1.0 : 0.5
        alpha = newAlpha
    }
}
