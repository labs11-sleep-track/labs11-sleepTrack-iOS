//
//  AudioPlayer.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/27/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioPlayerDelegate: AnyObject {
    func playerDidChangeState(_ player: AudioPlayer)
}

class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    weak var delegate: AudioPlayerDelegate?
    
    var currentURL: URL? {
        return audioPlayer?.url
    }
    
    var currentData: Data? {
        return audioPlayer?.data
    }
    
    var isPlaying: Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func load(file: URL) {
        if audioPlayer?.url != file {
            audioPlayer = try? AVAudioPlayer(contentsOf: file)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
        }
    }
    
    // MARK: - AV Audio AudioPlayer Delegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetTimer()
        notifyDelegate()
    }
    
    // MARK: - Utility Methods
    private func notifyDelegate() {
        delegate?.playerDidChangeState(self)
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
    }
}
