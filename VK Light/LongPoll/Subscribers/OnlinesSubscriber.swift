//
//  OnlinesSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 01/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol OnlinesSubscriber : class {
    func onlineStatusChanged(for user: Int, status: Bool)
    var watchedOnlines: [Int] { get }
    var watchesAllOnlines: Bool { get }
}
