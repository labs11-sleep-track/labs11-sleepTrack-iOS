//
//  MainTabBarController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/28/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = .accentColor
        selectedIndex = 1
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if User.current == nil { performSegue(withIdentifier: "ShowLoginSegue", sender: self) }
    }

}
