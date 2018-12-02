//
//  MenuCounterSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol MenuCounterSubscriber : class {
    func counterChanged(newCount: Int)
}
