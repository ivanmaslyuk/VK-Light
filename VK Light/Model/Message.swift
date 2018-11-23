//
//  Message.swift
//  VK Light
//
//  Created by Иван Маслюк on 19/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct Message {
    enum MessageType {
        case sticker
        case text
    }
    
    let peerId: Int
    let text : String
    let sticker : VKStickerModel?
    //let peer : VKConversationModel.Peer
    let profile : VKProfileModel?
    let group : VKGroupModel?
    //let chat : VKConversationModel.ChatSettings?
    let isFromMe : Bool
}
