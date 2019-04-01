//
//  TestingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class TestingViewController: UIViewController {

    let dailyDataController = DailyDataController()
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func generateDailyData(_ sender: Any) {
        DailyDataController.current = DailyData.generateSample(for: datePicker.date)
    }
    
    @IBAction func postDailyData(_ sender: Any) {
        dailyDataController.postDailyData()
    }
}
