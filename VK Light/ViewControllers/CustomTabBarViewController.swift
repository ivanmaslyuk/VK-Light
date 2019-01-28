//
//  CustomTabBarViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 20/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    var isInitialized = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isInitialized {
            selectedIndex = 1
            isInitialized = true
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
}
