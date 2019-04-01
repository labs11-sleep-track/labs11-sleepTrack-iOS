//
//  MotionManager.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import CoreMotion

protocol MotionManagerDelegate: class {
    func motionManager(_ motionManager: MotionManager, didChangeTrackingTo: Bool)
}

class MotionManager {
    
    // Singleton because you should only have one instance of CMMotionManager
    static let shared = MotionManager()
    private init () {
        dateFormatter.formatOptions = [.withInternetDateTime]
    }
    
    // MARK: - Properties
    private let motion = CMMotionManager()
    private var intervalTimer: Timer?
    private var readTimer: Timer?
    private var accumulator: Double = 0
    private(set) var motionDataArray: [MotionData] = []
    private let dateFormatter = ISO8601DateFormatter()
    
    
    weak var delegate: MotionManagerDelegate?
    // Chunk data into 10 minute intervals by default
    var intervalTime: TimeInterval = 60.0 * 10
    var readTime: TimeInterval = 1.0
    
    var isTracking: Bool { return intervalTimer != nil }
    
    func startTracking() {
        startTrackingMotion()
        intervalTimer = Timer.scheduledTimer(withTimeInterval: intervalTime, repeats: true, block: { _ in
            self.startNewInterval()
        })
        delegate?.motionManager(self, didChangeTrackingTo: isTracking)
    }
    
    func stopTracking() {
        // TODO: Get fire date and figure out interval to find the factor to multiply the current accumulator by to approximate the data
        intervalTimer?.invalidate()
        intervalTimer = nil
        saveToPersistentStore()
        delegate?.motionManager(self, didChangeTrackingTo: isTracking)
    }
    
    func toggleTracking() {
        if isTracking {
            stopTracking()
        } else {
            startTracking()
        }
    }
    
    // MARK: - Utility Methods
    @objc private func startNewInterval() {
        // Stop the current read timer
        readTimer?.invalidate()
        readTimer = nil
        
        // TODO: Set the date to be the middle of the time period, not the end. (data - intervalTime/2)
        // Add the accumulated data to the array and reset
        let motionData = MotionData(motion: accumulator, timestamp: Int(Date().timeIntervalSince1970))
        motionDataArray.append(motionData)
        accumulator = 0
        
        // Start the timer again
        startTrackingMotion()
    }
    
    private func startTrackingMotion() {
        if motion.isDeviceMotionAvailable {
            self.motion.deviceMotionUpdateInterval = readTime
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            self.readTimer = Timer(fire: Date(), interval: (readTime), repeats: true,
                                   block: { (timer) in
                                    if let data = self.motion.deviceMotion {
                                        
                                        // Get the acceleration of the phone minus gravity
                                        let x = data.userAcceleration.x
                                        let y = data.userAcceleration.y
                                        let z = data.userAcceleration.z
                                        
                                        // Average it out and add it to the accumulator
                                        let average = abs(x) + abs(y) + abs(z) / 3
                                        self.accumulator += average
                                    }
            })
            
            // Add the timer to the current run loop.
            RunLoop.current.add(self.readTimer!, forMode: RunLoop.Mode.default)
        }
    }
    
    // Currently saving to persistent store just to get access to sample JSON without networking. Final implementation won't need this
    private func saveToPersistentStore() {
        
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            NSLog("Couldn't get document directory")
            return
        }
        
        // Make a unique, time-stamped url to save to
        let formattedDate = dateFormatter.string(from: Date())
        let saveURL = documentsDirectory.appendingPathComponent("motion-data-\(formattedDate)").appendingPathExtension("json")
        
        // Try to write the data
        do {
            let data = try JSONEncoder().encode(motionDataArray)
            try data.write(to: saveURL, options: [.atomic])
            print("Saved the data to \(saveURL)")
        } catch {
            NSLog("Error encoding or saving data: \(error)")
        }
        
    }
    
}
