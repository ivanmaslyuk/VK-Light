//
//  Dialog.swift
//  VK Light
//
//  Created by Иван Маслюк on 23/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct Dialog {
    var title: String
    var peerType: VKConversationModel.Peer.PeerType
    var peerId: Int
    var unreadCount: Int?
    
    var messages: [Message]
}
