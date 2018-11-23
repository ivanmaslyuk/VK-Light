//
//  MessageHelper.swift
//  VK Light
//
//  Created by Иван Маслюк on 19/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class MessageHelper {
    let api = VKMessagesApi()
    let defaults = UserDefaults.standard
    
    func getMessages(peerId: Int, startMessageId: Int, offset: Int = 0, count: Int = 20) -> [Message]? {
        guard let response = api.getHistory(peerId: peerId, startMessageId: startMessageId, count: count, offset: offset, extended: true)?.response else {return nil}
        let currentUserId = defaults.string(forKey: "vk_user_id")
        
        var messages : [Message] = []
        for message in response.items {
            let fromMe = String(message.fromId) == currentUserId
            var sticker : VKStickerModel? = nil
            if message.attachments.count > 0 {
                if let s = message.attachments[0].sticker {
                    sticker = s
                }
            }
            let msg = Message(peerId: message.peerId!, text: message.text, sticker: sticker, profile: response.getProfileById(id: message.fromId), group: response.getGroupById(id: -message.fromId), isFromMe: fromMe)
            messages.append(msg)
        }
        
        return messages
    }
}
