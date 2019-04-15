//
//  SelectedSongViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/15/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MediaPlayer

class SongSelectViewController: UIViewController, MPMediaPickerControllerDelegate {
    
    var mediaItem: MPMediaItem?
    private(set) var state: State?

    private var stackView: UIStackView!
    private var imageView: UIImageView!
    private var labelStackView: UIStackView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var playButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        loadStoredMediaItem()
        if state == nil { transitionToState(.none) }
    }
    
    
    // MARK: - State
    enum State {
        case none
        case selected(MPMediaItem)
        
    }
    
    func transitionToState(_ state: State) {
        self.state = state
        switch state {
        case .none:
            loadDefaultSound()
        case .selected(let mediaItem):
            loadMediaItem(mediaItem)
        }
    }
    
    // MARK: - MPMediaPickerControllerDelegate
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        if let mediaItem = mediaItemCollection.items.first {
            transitionToState(.selected(mediaItem))
        }
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true)
    }
    
    // MARK: - Utility Methods
    private func setUpViews() {
        view.setupBorder()
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        
        stackView.constrainToSuperView(view, safeArea: false, top: 8, bottom: 8, leading: 8, trailing: 8)
        
        imageView = UIImageView()
        imageView.backgroundColor = .darkBlue
        stackView.addArrangedSubview(imageView)
        
        imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1, constant: 0).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1, constant: 0).isActive = true
        
        labelStackView = UIStackView()
        labelStackView.axis = .vertical
        
        stackView.addArrangedSubview(labelStackView)
        
        titleLabel = UILabel.customLabel(with: "")
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        labelStackView.addArrangedSubview(titleLabel)
        
        detailLabel = UILabel.customLabel(with: "", and: colorFor(state: .none))
        detailLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        detailLabel.textAlignment = .center
        labelStackView.addArrangedSubview(detailLabel)
        
        playButton = UIButton.customButton()
        playButton.setImage(UIImage(named: "play")!, for: .normal)
        stackView.addArrangedSubview(playButton)
        
        playButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1, constant: 16).isActive = true
        playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 1, constant: -16).isActive = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickSong))
        gestureRecognizer.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func colorFor(state: State) -> UIColor {
        switch state {
        case .none:
            return .darkBlue
        case .selected(_):
            return .customWhite
        }
    }
    
    private func loadDefaultSound() {
        self.mediaItem = nil
        
        let color = colorFor(state: state!)
        view.layer.borderColor = color.cgColor
        
        titleLabel.text = "Default Alarm Sound"
        titleLabel.textColor = color
        
        detailLabel.text = "Tap to select song"
        detailLabel.textColor = color
        
    }
    
    private func loadMediaItem(_ mediaItem: MPMediaItem) {
        self.mediaItem = mediaItem
        
        let color = colorFor(state: state!)
        view.layer.borderColor = color.cgColor
        
        if let title = mediaItem.title {
            titleLabel.text = title
            titleLabel.textColor = color
        }
        
        if let image = mediaItem.artwork?.image(at: imageView.frame.size) {
            imageView.image = image
        }
        
        detailLabel.text = "Tap to switch songs"
        
        saveMediaItem()
        
    }
    
    @objc private func pickSong() {
        switch (MPMediaLibrary.authorizationStatus()) {
        case .authorized:
            presentMusicPicker()
        default:
            // TODO: Handle not having permission better
            break
        }
    }
    
    private func presentMusicPicker() {
        let mediaPickerVC = MPMediaPickerController(mediaTypes: MPMediaType.music)
        mediaPickerVC.allowsPickingMultipleItems = false
        mediaPickerVC.showsCloudItems = false
        mediaPickerVC.prompt = "Pick a song for your alarm"
        mediaPickerVC.popoverPresentationController?.sourceView = view
        mediaPickerVC.delegate = self
        self.present(mediaPickerVC, animated: true, completion: nil)
    }
    
    private func saveMediaItem() {
        guard let mediaItem = self.mediaItem else { return }
        UserDefaults.standard.removeObject(forKey: .savedMediaItem)
        do {
            let dictionary = ["id" : mediaItem.persistentID]
            let encodedItemID = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            UserDefaults.standard.set(encodedItemID, forKey: .savedMediaItem)
        } catch {
            NSLog("Error saving media item: \(error)")
        }
    }
    
    private func loadStoredMediaItem() {
        guard let data = UserDefaults.standard.object(forKey: .savedMediaItem) as? Data else { return }
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let mediaID = jsonDict["id"]
            let predicate = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyPersistentID)
            let query = MPMediaQuery(filterPredicates: [predicate])
            if let mediaItem = query.items?.first {
                transitionToState(.selected(mediaItem))
            }
        } catch {
            NSLog("Error loading media item: \(error)")
        }
    }

}
