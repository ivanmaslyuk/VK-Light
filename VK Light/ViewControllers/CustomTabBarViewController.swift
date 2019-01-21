//
//  CustomTabBarViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 20/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import UIKit

class CustomTabBarViewController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tabBar(_ tabBar: UITabBar, didEndCustomizing items: [UITabBarItem], changed: Bool) {
        super.tabBar(tabBar, didEndCustomizing: items, changed: changed)
        selectedIndex = 1
    }
}
