//
//  SleepTrackingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SleepTrackingViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    let calendar = Calendar.current
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
//        let suggestedTime = calendar.date(byAdding: .hour, value: 8, to: Date())!
//        alarmTimePicker.setDate(suggestedTime, animated: true)
//        alarmTimePicker.minimumDate = Date()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
