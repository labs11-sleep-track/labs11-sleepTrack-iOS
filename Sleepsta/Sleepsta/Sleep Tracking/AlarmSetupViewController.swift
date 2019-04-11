//
//  AlarmSetupViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MediaPlayer


class AlarmSetupViewController: SLViewController, SLDatePickerViewDelegate, MPMediaPickerControllerDelegate {

    // MARK: - Properties
    private var mediaItem: MPMediaItem? {
        didSet { updateMediaItem() }
    }
    
    // These labels are mostly to show that I am getting data, won't be a part of the final design.
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var hourMinuteLabel: UILabel!
    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var goToSleepButton: UIButton!
    @IBOutlet weak var pickSongButton: UIButton!
    @IBOutlet weak var volumeControlContainer: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        alarmTimePicker.setDateTo(8, component: .hour)
    }
    
    // MARK: - UI Actions
    @IBAction func goToSleep(_ sender: Any) {
        let sleepTrackingPresentationVC = SLSleepTrackingPresentationViewController()
        sleepTrackingPresentationVC.alarmManager.mediaItem = mediaItem
        sleepTrackingPresentationVC.alarmManager.setAlarm(for: alarmTimePicker.date)
        present(sleepTrackingPresentationVC, animated: true)
    }
    
    @IBAction func pickNewSong(_ sender: UIButton) {
        switch (MPMediaLibrary.authorizationStatus()) {
        case .authorized:
            presentMediaPicker(sender)
        default:
            // TODO: Handle not having permission better
            break
        }
    }
    
    // MARK: - SL Date Picker View Delegate
    func datePicker(_ datePicker: SLDatePickerView, didChangeDate: Bool) {
        updateLabels()
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        mediaItem = mediaItemCollection.items.first
        
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    // MARK: - Utility Methods
    private func setupViews() {
        
        welcomeLabel.textColor = .customWhite
        
        userIDLabel.textColor = .customWhite
        userIDLabel.text = "" //\(User.current?.email ?? "")"
        
        hourMinuteLabel.textColor = .customWhite
        
        goToSleepButton.setTitleColor(.accentColor, for: .normal)
        pickSongButton.setTitleColor(.accentColor, for: .normal)
        
        let volumeControl = MPVolumeView(frame: volumeControlContainer.bounds)
        volumeControl.showsRouteButton = false
        volumeControl.tintColor = .accentColor
        volumeControlContainer.addSubview(volumeControl)
        volumeControlContainer.backgroundColor = .clear
        
        alarmTimePicker.datePickerDelegate = self
        alarmTimePicker.setDateTo(8, component: .hour)
        
    }
    
    private func updateLabels() {
        welcomeLabel.text = "Welcome \(User.current?.firstName ?? "")!"
        
        hourMinuteLabel.text = "Sleep for \(alarmTimePicker.hoursFromNow) hours and \(alarmTimePicker.minutesFromNow)ish minutes"
    }
    
    private func updateMediaItem() {
        if let mediamTitle = mediaItem?.title {
            pickSongButton.setTitle("Wake up to \"\(mediamTitle)\"", for: .normal)
        } else {
            pickSongButton.setTitle("Pick a song from your Music Library", for: .normal)
        }
    }
    
    private func presentMediaPicker(_ sender: UIView) {
        let mediaPickerVC = MPMediaPickerController(mediaTypes: MPMediaType.music)
        mediaPickerVC.allowsPickingMultipleItems = false
        mediaPickerVC.showsCloudItems = false
        mediaPickerVC.prompt = "Pick a song for your alarm"
        mediaPickerVC.popoverPresentationController?.sourceView = sender
        mediaPickerVC.delegate = self
        self.present(mediaPickerVC, animated: true, completion: nil)
    }
}
