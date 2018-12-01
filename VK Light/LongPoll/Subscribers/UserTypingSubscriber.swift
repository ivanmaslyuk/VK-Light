//
//  UserTypingSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 01/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol UserTypingSubscriber : class {
    func userStartedTyping(userId: Int)
    func watchingTypingFromUser() -> Int
    func watchesTypingFromAllUsers() -> Bool
}
