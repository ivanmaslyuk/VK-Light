//
//  MessageFlagsSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct MessageIdAndFlags {
    let messageId: Int
    let flags: VKLPMessageFlags
}

protocol MessageFlagsSubscriber : class {
    func messageFlagsChanged(peerId: Int, messages: [MessageIdAndFlags])
    func watchesMessageFlagsForPeer() -> Int
    func watchesMessageFlagsForAllPeers() -> Bool
}
