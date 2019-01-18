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
    
    func loadMessages(peerId: Int, startId: Int, offset: Int, count: Int = 20, completionHandler: @escaping ([VKMessageWrapper]?, Int?) -> Void) {
        DispatchQueue.global().async {
            let response = self.api.getHistory(peerId: peerId, startMessageId: startId, count: count, offset: offset, extended: true)
            if let response = response?.response {
                var messages : [VKMessageWrapper] = []
                for message in response.items {
                    messages.append(self.wrapMessage(msg: message, response: response))
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
    
    func loadDialogs() {}
    
    private func wrapMessage(msg: VKMessageModel, response: VKGetHistoryResponse) -> VKMessageWrapper {
        let profile = response.findProfileById(id: msg.fromId)
        let group = response.findGroupById(id: -msg.fromId)
        
        var wrappedForwarded = [VKMessageWrapper]()
        if let forwarded = msg.fwdMessages {
            for f in forwarded {
                let wrapped = wrapMessage(msg: f, response: response)
                wrappedForwarded.append(wrapped)
            }
        }
        
        let wrapper = VKMessageWrapper.init(message: msg, profile: profile, group: group, forwardedMessages: wrappedForwarded)
        return wrapper
    }
    
}
