//
//  StatsPageViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class StatsPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    

    let dailyDataController = DailyDataController()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        
        dailyDataController.fetchDailyData {
            DispatchQueue.main.async {
                if let viewController = self.statsViewController(self.dailyDataController.dailyDatas.count-1) {
                    let viewControllers = [viewController]
                    
                    self.setViewControllers(viewControllers, direction: .forward, animated: false)
                }
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? StatsViewController, let dailyData = viewController.dailyData, let index = dailyDataController.dailyDatas.index(of: dailyData) {
            return statsViewController(index - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? StatsViewController, let dailyData = viewController.dailyData, let index = dailyDataController.dailyDatas.index(of: dailyData)  {
            return statsViewController(index + 1)
        }
        return nil
    }


    private func statsViewController(_ index: Int) -> StatsViewController? {
        guard index < dailyDataController.dailyDatas.count, index >= 0, let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as? StatsViewController else {
            return nil
        }
        
        page.dailyData = dailyDataController.dailyDatas[index]
        return page
    }
    
    

}
