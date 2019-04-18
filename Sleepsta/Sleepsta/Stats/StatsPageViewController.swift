//
//  StatsPageViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class StatsPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, StatsViewControllerDelegate {
    
    // MARK: - Properties
    let dailyDataController = DailyDataController()
    
    private var currentIndex: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        dataSource = self
        
        view.backgroundColor = .black
        
        loadViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Fetch the user's data to display on the stats page
        dailyDataController.fetchDailyData { if self.dailyDataController.dailyDatas.count > 0 { self.loadViewController() }}
    }
    
    // MARK: - Page View Controller Data Source
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
    
    // MARK: Page View Controller Delegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let page = pageViewController.viewControllers?[0] as? StatsViewController, let dailyData = page.dailyData, let index = dailyDataController.dailyDatas.index(of: dailyData) else {
            currentIndex = 0
            return
        }
        currentIndex = index
    }
    
    // MARK: - Stats View Controller Delegate
    func statsVC(_ statsVC: StatsViewController, didDelete dailyData: DailyData) {
        dailyDataController.deleteDailyData(dailyData) { (error) in
            if let error = error {
                NSLog("Error deleting daily data: \(error)")
            } else {
                self.loadViewController()
            }
        }
    }

    // MARK: - Utility Methods
    private func statsViewController(_ index: Int) -> StatsViewController? {
        guard index < dailyDataController.dailyDatas.count,index >= 0, let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: "StatsViewController") as? StatsViewController else {
            return nil
        }
        
        page.dailyData = dailyDataController.dailyDatas[index]
        page.delegate = self
        
        if index != dailyDataController.dailyDatas.count-1 { page.isLast = false }
        if index != 0 { page.isFirst = false }
        return page
    }
    
    private func loadViewController() {
        DispatchQueue.main.async {
            if self.viewControllers?.count ?? 0 < 1 {
                // If there are no view controllers, load the intial one
                let index = self.dailyDataController.dailyDatas.count-1
                if let viewController = self.statsViewController(index) {
                    let viewControllers = [viewController]
                    
                    self.currentIndex = index
                    self.setViewControllers(viewControllers, direction: .forward, animated: false)
                } else {
                    self.setViewControllers([self.loadSampleStatsView()], direction: .forward, animated: false)
                }
            } else {
                // It means the data has changed
                if let viewController = self.statsViewController(self.currentIndex) {
                    // If the current index still exists, reload it
                    let viewControllers = [viewController]
                    self.setViewControllers(viewControllers, direction: .forward, animated: false)
                } else if let viewController = self.statsViewController(self.currentIndex-1) {
                    // Try loading the one below it
                    let viewControllers = [viewController]
                    self.setViewControllers(viewControllers, direction: .reverse, animated: true)
                    if self.currentIndex > 0 { self.currentIndex -= 1 }
                } else {
                    self.setViewControllers([self.loadSampleStatsView()], direction: .forward, animated: true)
                }
            }
        }
    }
    
    private func loadSampleStatsView() -> StatsViewController {
        let url = Bundle.main.url(forResource: "sample-data", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        let dailyData = try! JSONDecoder().decode(DailyData.self, from: data)
        
        guard let statsViewController = storyboard?.instantiateViewController(withIdentifier: "StatsViewController") as? StatsViewController else { fatalError("Wasn't able to instantiate a sample stats view controller") }
        
        statsViewController.dailyData = dailyData
        
        return statsViewController
    }
}
