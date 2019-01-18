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
    
    /*func getMessages(peerId: Int, startMessageId: Int, offset: Int = 0, count: Int = 20) -> [VKMessageWrapper]? {
        guard let response = api.getHistory(peerId: peerId, startMessageId: startMessageId, count: count, offset: offset, extended: true)?.response else {return nil}
        
        var messages : [VKMessageWrapper] = []
        for message in response.items {
            let profile = response.findProfileById(id: message.fromId)
            let group = response.findGroupById(id: -message.fromId)
            messages.append(VKMessageWrapper(message: message, profile: profile, group: group))
        }
        
        return messages
    }
    
    static func translateVKMessage(model: VKMessageModel, associatedProfile: VKProfileModel?, associatedGroup: VKGroupModel?) -> Message {
        
        var sticker : VKStickerModel? = nil
        if model.attachments.count > 0 {
            if let s = model.attachments[0].sticker {
                sticker = s
            }
        }
        
        var senderName: String = "Неизвестно"
        if let profile = associatedProfile {
            senderName = profile.firstName + " " + profile.lastName
        }
        if let group = associatedGroup {
            senderName = group.name
        }
        
        return Message(peerId: model.peerId!, text: model.text, sticker: sticker, senderName: senderName, isFromMe: model.out == 1)
    }*/
    
    func loadMessages(peerId: Int, startId: Int, offset: Int, count: Int = 20, completionHandler: @escaping ([VKMessageWrapper]?, Int?) -> Void) {
        DispatchQueue.global().async {
            let response = self.api.getHistory(peerId: peerId, startMessageId: startId, count: count, offset: offset, extended: true)
            if let response = response?.response {
                var messages : [VKMessageWrapper] = []
                for message in response.items {
                    /*let profile = response.findProfileById(id: message.fromId)
                    let group = response.findGroupById(id: -message.fromId)
                    
                    if let forwarded = message.fwdMessages {
                        for f in forwarded {
                            let profile = response.findProfileById(id: message.fromId)
                            let group = response.findGroupById(id: -message.fromId)
                            message.wrappedForwarded?.append(VKMessageWrapper(message: message, profile: profile, group: group))
                        }
                    }
                    
                    messages.append(VKMessageWrapper(message: message, profile: profile, group: group))*/
                    messages.append(self.wrap(msg: message, response: response))
                }
                
                DispatchQueue.main.async {
                    completionHandler(messages, nil)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, 1)
                }
            }
        }
    }
    
    private func wrap(msg: VKMessageModel, response: VKGetHistoryResponse) -> VKMessageWrapper {
        let profile = response.findProfileById(id: msg.fromId)
        let group = response.findGroupById(id: -msg.fromId)
        
        var wrappedForwarded = [VKMessageWrapper]()
        if let forwarded = msg.fwdMessages {
            for f in forwarded {
                let wrapped = wrap(msg: f, response: response)
                wrappedForwarded.append(wrapped)
            }
        }
        
        let wrapper = VKMessageWrapper.init(message: msg, profile: profile, group: group, forwardedMessages: wrappedForwarded)
        return wrapper
    }
    
}
