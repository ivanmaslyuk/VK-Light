//
//  RootViewController.swift
//  VK Light
//
//  Created by Иван Маслюк on 16/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "vk_token") != nil {
            self.performSegue(withIdentifier: "loggedIn", sender: nil)
        }
        else {
            self.performSegue(withIdentifier: "login", sender: nil)
        }
    }


}
