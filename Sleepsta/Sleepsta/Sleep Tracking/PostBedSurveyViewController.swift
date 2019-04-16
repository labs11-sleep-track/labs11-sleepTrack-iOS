//
//  PostBedSurveyViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/4/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

protocol PostBedSurveyViewControllerDelegate: class {
    func postBecSurveyVC(_ postBedSurveryVC: PostBedSurveyViewController, didSubmitSurvey: Bool, with notes: String)
}

class PostBedSurveyViewController: ShiftableViewController {

    weak var delegate: PostBedSurveyViewControllerDelegate?
    
    private var notesTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleLabel = UILabel.titleLabel(with: "How did you sleep?")
        titleLabel.constrainToSuperView(view, top: 16, leading: 24)

        let notesLabel = UILabel.customLabel(with: "Notes:")
        view.addSubview(notesLabel)
        notesLabel.constrainToSiblingView(titleLabel, leading: 0, below: 20)
        
        notesTextView = UITextView()
        notesTextView?.backgroundColor = .clear
        notesTextView?.tintColor = .accentColor
        notesTextView?.textColor = .customWhite
        notesTextView?.font = UIFont.preferredFont(forTextStyle: .body)
        notesTextView?.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        notesTextView?.delegate = self
        notesTextView?.setupBorder()
        notesTextView!.constrainToSuperView(view, leading: 20, trailing: 20, height: 240)
        notesTextView!.constrainToSiblingView(notesLabel, below: 8)
        
        let doneButton = UIButton.customButton(with: "Done")
        doneButton.addTarget(self, action: #selector(submitSurvey), for: .touchUpInside)
        doneButton.constrainToSuperView(view, safeArea: true, bottom: 24, centerX: 0)
    }
    
    @objc private func submitSurvey() {
        guard let notes = notesTextView?.text else { return }
        
        if DailyDataController.current.sleepTime < 600 {
            let dismissAction: (UIAlertAction) -> Void = { _ in self.delegate?.postBecSurveyVC(self, didSubmitSurvey: true, with: notes) }
            
            let cancelAction: (UIAlertAction) -> Void = { _ in self.dismiss(animated: true) }
            
            let alertController = UIAlertController.informationalAlertController(title: "You didn't sleep very long", withCancel: true, message: "You can only save one sleep data per day, and this one is only a few minutes, are you sure you want to save it?", dismissTitle: "Save Anyway", dismissActionCompletion: dismissAction, cancelActionCompletion: cancelAction)
            present(alertController, animated: true)
        } else {
            delegate?.postBecSurveyVC(self, didSubmitSurvey: true, with: notes)
        }
    }

}
