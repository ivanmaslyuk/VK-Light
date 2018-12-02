//
//  MessageEditedSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol MessageEditedSubscriber : class {
    func messageWasEdited(editedMessage: VKMessageWrapper)
    func watchesMessageEditsForPeer() -> Int
    func watchesMessageEditsForAllPeers() -> Bool
}
