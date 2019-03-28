//
//  StatsViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/28/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController {
    var motionData: [MotionData] = []

    @IBOutlet weak var lineChart: LineChartView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        loadData()
        setupChart()
        updateChart()
    }

    private func loadData() {
        let url = Bundle.main.url(forResource: "sample-motion-data", withExtension: ".json")!
        let data = try! Data(contentsOf: url)
        let array = try! JSONDecoder().decode([MotionData].self, from: data)
        motionData = array
    }
    
    private func setupChart() {
        lineChart.xAxis.labelTextColor = .white
        lineChart.xAxis.labelFont = UIFont.preferredFont(forTextStyle: .caption1)
        lineChart.xAxis.labelRotationAngle = 45
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.valueFormatter = TimeXAxisValueFormatter()
        lineChart.legend.enabled = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.backgroundColor = .clear
        lineChart.chartDescription?.textColor = .white
        lineChart.highlightPerTapEnabled = false
        lineChart.highlightPerDragEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.drawBordersEnabled = true
        lineChart.borderColor = .darkGray
        
        lineChart.noDataText = "No motion data for this day"
        lineChart.noDataTextColor = .white
        lineChart.noDataFont = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    private func updateChart() {
        guard !motionData.isEmpty else { return }
        var entries: [ChartDataEntry] = []
        for dataPoint in motionData {
            let entry = ChartDataEntry(x: Double(dataPoint.timestamp), y: dataPoint.motion)
            entries.append(entry)
        }
        let dataSet = LineChartDataSet(values: entries, label: nil)
        dataSet.setColor(.accentColor, alpha: 1.0)
        dataSet.drawCirclesEnabled = false
        dataSet.fillColor = .accentColor
        dataSet.drawFilledEnabled = true
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        let data = LineChartData(dataSet: dataSet)
        lineChart.data = data
        
        lineChart.notifyDataSetChanged()
    }
}

class TimeXAxisValueFormatter: IAxisValueFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        return dateFormatter
    }()
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return TimeXAxisValueFormatter.dateFormatter.string(from: date)
    }
    
    
}
