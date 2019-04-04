//
//  PreBedSurveyViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/3/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

protocol PreBedSurveyViewControllerDelegate: class {
    func preBedSurveyViewController(_ preBedSurveyViewController: PreBedSurveyViewController, didHitNextButton: Bool)
}

class PreBedSurveyViewController: UIViewController {

    weak var delegate: PreBedSurveyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.accentColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(cancelButton)
       
        let testButton = UIButton(type: .custom)
        testButton.setTitle("Next", for: .normal)
        testButton.setTitleColor(.accentColor, for: .normal)
        testButton.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
        stackView.addArrangedSubview(testButton)
    }

    
    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc private func testButtonPressed() {
        delegate?.preBedSurveyViewController(self, didHitNextButton: true)
    }
}
