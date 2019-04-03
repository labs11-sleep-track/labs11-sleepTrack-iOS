//
//  SLSlideControl.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/3/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLSlideControl: UIControl {
    
    // MARK: - Properties
    var isUnlocked: Bool = false
    private var imageView: UIImageView!
    private var barView: UIView!
    private var thumb: UIView!
    private var instructionLabel: UILabel!
    
    // MARK: - Public API
    /// Resets the lock control back to its original state.
    func reset() {
        if thumb != nil { slideThumb(to: 6) }
        isUnlocked = false
    }
    
    // MARK: - Lifecycle Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupControl()
    }
    
    // MARK: - UI Control
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Only begin tracking if the user touches down inside of the thumb
        let touchPoint = touch.location(in: thumb)
        if thumb.bounds.contains(touchPoint) {
            sendActions(for: .touchDown)
            return true
        }
        return false
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // Send the proper action if the user drags inside or outside of the slider bar
        let touchPoint = touch.location(in: barView)
        if barView.bounds.contains(touchPoint) {
            sendActions(for: .touchDragInside)
        } else  {
            sendActions(for: .touchDragOutside)
        }
        // But update the thumb's position no matter where they drag.
        let percentage = calculatePercentage(with: touchPoint)
        let possibleWidth = barView.bounds.width - thumb.bounds.width - 12
        let offset = (percentage * possibleWidth) + 6
        thumb.frame = thumbOffset(by: offset)
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        defer { super.endTracking(touch, with: event) }
        // Make sure there is a touch and that the lock is not already unlocked
        guard let touch = touch, !isUnlocked else { return }
        // Calculate the percentage through the slider bar
        let touchPoint = touch.location(in: barView)
        let percentage = calculatePercentage(with: touchPoint)
        if percentage > 0.8 {
            // If it is more than 80 percent, unlock the control, update the image and send the action.
            isUnlocked = true
            let endPoint = barView.bounds.width - thumb.bounds.width - 6
            if thumb.frame.origin.x != endPoint {
                slideThumb(to: endPoint) { _ in self.sendActions(for: .valueChanged) }
            }
        } else {
            // Otherwise, reset it.
            reset()
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        // If tracking is cancelled, send that action and reset the control.
        sendActions(for: .touchCancel)
        reset()
    }
    
    override var intrinsicContentSize: CGSize { return CGSize(width: 300.0, height: 62.0) }
    
    // MARK: - Utility Methods
    /// Sets up a new Lock Control
    private func setupControl() {
        
        barView?.removeFromSuperview()
        thumb?.removeFromSuperview()
        instructionLabel?.removeFromSuperview()
        
        // Set the background color and corner radius of control
        backgroundColor = .clear
        layer.cornerRadius = 30
        
        // Set up the view for the slider bar
        barView = UIView(frame: CGRect(x: 6, y: 6, width: bounds.width - 12, height: bounds.height - 12))
        addSubview(barView)
        barView.backgroundColor = .fadedDarkBlue
        barView.layer.cornerRadius = barView.bounds.height / 2
        barView.isUserInteractionEnabled = false
        
        // Set up the label
        instructionLabel = UILabel(frame: barView.bounds)
        instructionLabel.text = "Slide to unlock"
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .lighterBackgroundColor
        instructionLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        barView.addSubview(instructionLabel)
        
        // Set up the view for the thumb
        thumb = UIView(frame: thumbOffset(by: 6))
        barView.addSubview(thumb)
        thumb.backgroundColor = .customWhite
        thumb.layer.cornerRadius = thumb.bounds.height/2
//        thumb.layer.borderColor = UIColor.accentColor.cgColor
//        thumb.layer.borderWidth = 2
        thumb.isUserInteractionEnabled = false
    }
    
    /// Calculates a percentage travelled within the slider bar, with provisions for travelling beyond it.
    private func calculatePercentage(with point: CGPoint) -> CGFloat {
        var percentage = point.x / (barView.bounds.width)
        if percentage > 1.0 {
            percentage = 1.0
        } else if percentage < 0.0 {
            percentage = 0.0
        }
        return percentage
    }
    
    /// Returns the new frame for the thumb offest by the given point.
    private func thumbOffset(by offset: CGFloat) -> CGRect {
        let size = barView.bounds.height - 12
        return CGRect(x: offset, y: 6, width: size, height: size)
    }
    
    /// Animates the thumb sliding to the given point.
    private func slideThumb(to point: CGFloat, completion: @escaping (Bool) -> Void = { _ in }) {
        let animations = { self.thumb.frame = self.thumbOffset(by: point) }
        UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
    }
}
