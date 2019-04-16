//
//  PreBedSurveyViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/3/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MediaPlayer

protocol PreBedSurveyViewControllerDelegate: class {
    func preBedSurveyViewController(_ preBedSurveyViewController: PreBedSurveyViewController, didHitNextButton: Bool)
}

class PreBedSurveyViewController: UIViewController {

    weak var delegate: PreBedSurveyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // MARK: - Utilty Methods
    private func setupViews() {
        let imageView = UIImageView(image: UIImage(named: "phone-placement-graphic"))
        imageView.contentMode = .scaleAspectFit
        imageView.constrainToSuperView(view, top: 20, leading: 0, trailing: 0)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: (435/1125)).isActive = true
        
        let placementLabel = UILabel.subtitleLabel(with: "For best results, place your phone on the corner of your bed, face down and plugged in.")
        placementLabel.textAlignment = .center
        placementLabel.numberOfLines = 0
        placementLabel.constrainToSuperView(view, leading: 24, trailing: 24)
        placementLabel.constrainToSiblingView(imageView, below: 32)
        
        let continueButton = UIButton.customButton(with: "Continue")
        continueButton.addTarget(self, action: #selector(testButtonPressed), for: .touchUpInside)
        continueButton.constrainToSuperView(view, bottom: 20, centerX: 0)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 32.0
        stackView.constrainToSuperView(view, centerX: 0)
        stackView.constrainToSiblingView(continueButton, above: 48, width: 240)
        
        let volumeLabel = UILabel.subtitleLabel(with: "And don't forget to set your alarm volume:")
        volumeLabel.textAlignment = .center
        volumeLabel.numberOfLines = 0
        stackView.addArrangedSubview(volumeLabel)
        
        let volumeControlContainer = UIView()
        volumeControlContainer.constrain(height: 20)
        stackView.addArrangedSubview(volumeControlContainer)
        volumeControlContainer.backgroundColor = .clear
        
        let volumeControl = MPVolumeView(frame: volumeControlContainer.bounds)
        volumeControl.showsRouteButton = false
        volumeControl.tintColor = .accentColor
        volumeControl.constrainToFill(volumeControlContainer)
        
    }
    
    @objc private func testButtonPressed() {
        delegate?.preBedSurveyViewController(self, didHitNextButton: true)
    }
}
