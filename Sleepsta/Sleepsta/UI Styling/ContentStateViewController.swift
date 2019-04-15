//
//  ContentStateViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/13/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class ContentStateViewController: UIViewController {

    private var state: State?
    private var shownViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if state == nil { transition(to: .loading) }
    }
    
    // MARK: - Public API
    func transition(to newState: State) {
        shownViewController?.remove()
        let viewController = self.viewController(for: newState)
        add(viewController)
        shownViewController = viewController
        state = newState
    }
    
    // MARK: - States
    enum State {
        case loading
        case failed(Error)
        case render(UIViewController)
    }
    
    func viewController(for state: State) -> UIViewController {
        switch state {
        case .loading:
            // TODO: Add a Loading View Controller
            return UIViewController()
        case .failed(let error):
            // TODO: Add an Error View Controlller
            print(error)
            return UIViewController()
        case .render(let viewController):
            return viewController
        }
    }

}


