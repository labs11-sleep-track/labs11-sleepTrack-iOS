//
//  UIAlertController+InformationalAlert.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/27/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func informationalAlertController(title: String? = "Error", withCancel: Bool = false, message: String?, dismissTitle: String = "Dismiss", dismissActionCompletion: ((UIAlertAction) -> Void)? = nil, cancelActionCompletion: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: dismissTitle, style: .default, handler: dismissActionCompletion)
        
        alertController.addAction(dismissAction)
        
        if withCancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelActionCompletion)
            alertController.addAction(cancelAction)
        }
        
        return alertController
    }
}
