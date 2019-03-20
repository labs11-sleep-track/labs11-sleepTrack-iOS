//
//  ShiftableViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

///Set the subclass of ShiftableViewController as the delegate for all UITextFields and UITextViews that you want to be shifted out of the way of the keyboard.
class ShiftableViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    
    // MARK: - Properties
    var currentYShiftForKeyboard: CGFloat = 0
    var textFieldBeingEdited: UITextField?
    var textViewBeingEdited: UITextView?
    var keyboardDismissTapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissTapGestureRecognizer()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UI Text Field Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldBeingEdited = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UI Text View Delegate
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textViewBeingEdited = textView
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    // MARK: - Notification Handlers
    @objc private func keyboardWillShow(notification: Notification) {
        
        keyboardDismissTapGestureRecognizer.isEnabled = true
        var keyboardSize: CGRect = .zero
        
        if let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            keyboardRect.height != 0 {
            keyboardSize = keyboardRect
        } else if let keyboardRect = notification.userInfo?["UIKeyboardBoundsUserInfoKey"] as? CGRect {
            keyboardSize = keyboardRect
        }
        
        if let textField = textFieldBeingEdited  {
            if self.view.frame.origin.y == 0 {
                
                let yShift = yShiftWhenKeyboardAppearsFor(textInput: textField, keyboardSize: keyboardSize, nextY: keyboardSize.height)
                self.currentYShiftForKeyboard = yShift
                self.view.frame.origin.y -= yShift
            }
        } else if let textView = textViewBeingEdited {
            if self.view.frame.origin.y == 0 {
                
                let yShift = yShiftWhenKeyboardAppearsFor(textInput: textView, keyboardSize: keyboardSize, nextY: keyboardSize.height)
                self.currentYShiftForKeyboard = yShift
                self.view.frame.origin.y -= yShift
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        if self.view.frame.origin.y != 0 { self.view.frame.origin.y += currentYShiftForKeyboard }
        stopEditingTextInput()
    }
    
    // MARK: - UI Utilities
    private func yShiftWhenKeyboardAppearsFor(textInput: UIView, keyboardSize: CGRect, nextY: CGFloat) -> CGFloat {
        
        let textFieldOrigin = self.view.convert(textInput.frame, from: textInput.superview!).origin.y
        let textFieldBottomY = textFieldOrigin + textInput.frame.size.height + 8
        
        // This is the y point that the textField's bottom can be at before it gets covered by the keyboard
        let maximumY = self.view.frame.height - (keyboardSize.height + view.safeAreaInsets.bottom)
        
        if textFieldBottomY > maximumY {
            // This makes the view shift the right amount to have the text field being edited just above they keyboard if it would have been covered by the keyboard.
            return textFieldBottomY - maximumY
        } else {
            // It would go off the screen if moved, and it won't be obscured by the keyboard.
            return 0
        }
    }
    
    @objc func stopEditingTextInput() {
        if let textField = self.textFieldBeingEdited {
            
            textField.resignFirstResponder()
            
            self.textFieldBeingEdited = nil
            self.textViewBeingEdited = nil
        } else if let textView = self.textViewBeingEdited {
            
            textView.resignFirstResponder()
            
            self.textFieldBeingEdited = nil
            self.textViewBeingEdited = nil
        }
        
        guard keyboardDismissTapGestureRecognizer.isEnabled else { return }
        
        keyboardDismissTapGestureRecognizer.isEnabled = false
    }
    
    private func setupKeyboardDismissTapGestureRecognizer() {
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(stopEditingTextInput))
        tapGestureRecognizer.numberOfTapsRequired = 1
        
        view.addGestureRecognizer(tapGestureRecognizer)
        
        keyboardDismissTapGestureRecognizer = tapGestureRecognizer
    }
}
