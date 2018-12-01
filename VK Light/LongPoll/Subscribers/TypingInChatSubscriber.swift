//
//  TypingInChatSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 01/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol TypingInChatSubscriber : class {
    func userStartedTypingInChat(userId: Int, chatId: Int)
    func watchingTypingInChat() -> Int
    func watchesTypingFromAllChats() -> Bool
}
