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
    
    // MARK: - Properties
    var mediaItem: MPMediaItem?
    private(set) var state: State?

    private var stackView: UIStackView!
    private var imageView: UIImageView!
    private var labelStackView: UIStackView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var playButton: UIButton!
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    private var mediaPlayer: MPMusicPlayerController!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
        
        loadStoredMediaItem()
        if state == nil { transitionToState(.none) }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mediaPlayer.stop()
        updatePlayButton()
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
        
        let headerLabel = UILabel.subtitleLabel(with: "Wake Up To:", and: .darkBlue)
        headerLabel.constrainToSuperView(view, leading: 0)
        headerLabel.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -4).isActive = true
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        
        stackView.constrainToSuperView(view, safeArea: false, top: 8, bottom: 8, leading: 8, trailing: 8)
        
        imageView = UIImageView()
        imageView.tintColor = .darkBlue
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.layer.masksToBounds = true
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
        playButton.addTarget(self, action: #selector(playSong), for: .touchUpInside)
        stackView.addArrangedSubview(playButton)
        
        playButton.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1, constant: 16).isActive = true
        playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor, multiplier: 1, constant: -16).isActive = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickSong))
        gestureRecognizer.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(gestureRecognizer)
        
        let deleteGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(removeSong))
        deleteGestureRecognizer.minimumPressDuration = 0.6
        
        view.addGestureRecognizer(deleteGestureRecognizer)
        
        mediaPlayer = MPMusicPlayerController.applicationMusicPlayer
        
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
        saveMediaItem()
        
        let color = colorFor(state: state!)
        view.layer.borderColor = color.cgColor
        
        titleLabel.text = "Default Alarm Sound"
        titleLabel.textColor = color
        
        detailLabel.text = "Tap to select song"
        detailLabel.textColor = color
        
        imageView.image = UIImage(named: "musical_notes")
        
        playButton.isEnabled = false
    }
    
    private func loadMediaItem(_ mediaItem: MPMediaItem) {
        self.mediaItem = mediaItem
        saveMediaItem()
        
        let color = colorFor(state: state!)
        view.layer.borderColor = color.cgColor
        
        if let title = mediaItem.title {
            titleLabel.text = title
            titleLabel.textColor = color
        }
        
        if let image = mediaItem.artwork?.image(at: imageView.frame.size) {
            imageView.image = image
        }
        
        detailLabel.text = "Tap to switch, hold to remove"
        
        playButton.isEnabled = true
        
        
    }
    
    @objc private func pickSong() {
        switch (MPMediaLibrary.authorizationStatus()) {
        case .authorized:
            presentMusicPicker()
            
        case .notDetermined:
            MPMediaLibrary.requestAuthorization { (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.presentMusicPicker()
                    }
                }
            }
        default:
            // TODO: Handle not having permission better
            break
        }
    }
    
    @objc private func removeSong() {
        if let state = state {
            switch state {
            case .selected(_):
                transitionToState(.none)
                notificationGenerator.notificationOccurred(.success)
            default:
                break
            }
        }
    }
    
    @objc private func playSong() {
        if let mediaItem = mediaItem {
            if mediaPlayer.nowPlayingItem != mediaItem || mediaPlayer.playbackState == .stopped  {
                mediaPlayer.setQueue(with: MPMediaItemCollection(items: [mediaItem]))
                mediaPlayer.play()
            } else {
                switch mediaPlayer.playbackState {
                case .playing:
                    mediaPlayer.pause()
                case .paused, .interrupted:
                    mediaPlayer.play()
                case .seekingForward, .seekingBackward, .stopped:
                    break
                }
            }
        }
        updatePlayButton()
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
        UserDefaults.standard.removeObject(forKey: .savedMediaItem)
        guard let mediaItem = self.mediaItem else { return }
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
    
    private func updatePlayButton() {
        let image: UIImage
        if mediaPlayer.playbackState == .playing {
            image = UIImage(named: "pause")!
        } else {
            image = UIImage(named: "play")!
        }
        playButton.setImage(image, for: .normal)
    }

}
