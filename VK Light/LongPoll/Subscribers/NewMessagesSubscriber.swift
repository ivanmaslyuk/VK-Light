//
//  NewMessagesSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 01/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol NewMessagesSubscriber : class {
    func newMessageReceived(message: VKMessageWrapper)
    var peerWatchedForMessages: Int { get }
    var watchesAllMessages: Bool { get }
}
