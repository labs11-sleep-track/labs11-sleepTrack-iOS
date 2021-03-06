//
//  StatsViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/28/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import Charts

protocol StatsViewControllerDelegate: class {
    func statsVC(_ statsVC: StatsViewController, didDelete dailyData: DailyData)
}

class StatsViewController: UIViewController {
    var dailyData: DailyData?
    var isLast: Bool = true
    var isFirst: Bool = true
    weak var delegate: StatsViewControllerDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var qualityLabel: UILabel!
    @IBOutlet weak var qualityTitleLabel: UILabel!
    @IBOutlet weak var bedTimeLabel: UILabel!
    @IBOutlet weak var bedTimeTitleLabel: UILabel!
    @IBOutlet weak var wakeTimeLabel: UILabel!
    @IBOutlet weak var wakeTimeTitleLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var deleteButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

        updateLineChart()
        updateLabels()
    }
    
    @IBAction func deleteDailyData(_ sender: Any) {
        guard let dailyData = dailyData else { return }
        delegate?.statsVC(self, didDelete: dailyData)
    }
    
    private func setupViews() {
        
        // Set up gradient background
        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        // Set up date label
        dateLabel.textColor = .customWhite
        
        // Set up line chart
        let leftAxis = lineChart.getAxis(.left)
        let rightAxis = lineChart.getAxis(.right)
        rightAxis.drawLabelsEnabled = false
        leftAxis.drawLabelsEnabled = false
        leftAxis.gridColor = .darkBlue
        rightAxis.gridColor = .darkBlue
        lineChart.xAxis.labelTextColor = .customWhite
        lineChart.xAxis.gridColor = .darkBlue
        lineChart.xAxis.labelFont = UIFont.preferredFont(forTextStyle: .caption1)
        lineChart.xAxis.labelRotationAngle = 45
        lineChart.xAxis.labelPosition = .bottom
        lineChart.xAxis.valueFormatter = TimeXAxisValueFormatter()
        lineChart.legend.enabled = false
        lineChart.drawGridBackgroundEnabled = false
        lineChart.backgroundColor = .clear
        lineChart.chartDescription?.textColor = .customWhite
        lineChart.highlightPerTapEnabled = false
        lineChart.highlightPerDragEnabled = false
        lineChart.pinchZoomEnabled = false
        lineChart.doubleTapToZoomEnabled = false
        lineChart.scaleYEnabled = false
        lineChart.drawBordersEnabled = true
        lineChart.borderColor = .darkBlue
        lineChart.noDataText = "No motion data for this day"
        lineChart.noDataTextColor = .white
        lineChart.noDataFont = UIFont.preferredFont(forTextStyle: .headline)
        
        // Set up quality, sleep time, and notes labels
        sleepTimeLabel.textColor = .customWhite
        qualityLabel.textColor = .customWhite
        qualityTitleLabel.textColor = .customWhite
        bedTimeLabel.textColor = .customWhite
        bedTimeTitleLabel.textColor = .customWhite
        wakeTimeLabel.textColor = .customWhite
        wakeTimeTitleLabel.textColor = .customWhite
        notesLabel.textColor = .customWhite
        
        // Set up notes text view
        notesTextView.textColor = .customWhite
        notesTextView.backgroundColor = .clear
        notesTextView.text = ""
        
        deleteButton.setTitleColor(.pink, for: .normal)
    }
    
    private func updateLabels() {
        guard isViewLoaded, let dailyData = dailyData else { return }
        
        var dateLabelText = dailyData.dateRangeString
        if !isFirst { dateLabelText = "← " + dateLabelText }
        if !isLast { dateLabelText = dateLabelText + " →" }
        dateLabel.text = dateLabelText
        
        sleepTimeLabel.text = dailyData.sleepTimeString
        
        qualityLabel.text = "\(dailyData.quality ?? -1)%"
        bedTimeLabel.text = dailyData.bedTimeString
        wakeTimeLabel.text = dailyData.wakeTimeString
        
        if let notes = dailyData.sleepNotes, !notes.isEmpty {
            notesTextView.text = notes
        } else {
            notesLabel.text = "No notes."
        }
        
        if dailyData.userID == -1 { deleteButton.isHidden = true }
    }
    
    private func updateLineChart() {
        guard let motionData = dailyData?.nightData, !motionData.isEmpty else { return }
        var entries: [ChartDataEntry] = []
        for dataPoint in motionData {
            let entry = ChartDataEntry(x: Double(dataPoint.timestamp), y: dataPoint.motion)
            entries.append(entry)
        }
        let dataSet = LineChartDataSet(values: entries, label: nil)
        dataSet.setColor(.accentColor, alpha: 1.0)
        dataSet.drawCirclesEnabled = false
        dataSet.lineWidth = 2
        dataSet.fillColor = .accentColor
        dataSet.fillAlpha = 0.5
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
