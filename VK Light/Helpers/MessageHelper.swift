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
    
    typealias LoadMessagesHandler = ([VKMessageWrapper]?, RequestFailureReason?) -> Void
    func loadMessages(peerId: Int, startId: Int, offset: Int, count: Int, completion: @escaping LoadMessagesHandler) {
        self.api.getHistory(peerId: peerId, startMessageId: startId, count: count, offset: offset, extended: true, completion: {(response, error) in
            if let response = response?.response {
                let wrapped = self.wrapMessages(response: response)
                DispatchQueue.main.async {
                    completion(wrapped, nil)
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        })
    }
    
    typealias LoadDialogsHandler = ([VKDialogWrapper]?, RequestFailureReason?) -> Void
    func loadDialogs(count: Int, offset: Int, completion: @escaping LoadDialogsHandler) {
        api.getConversations(count: count, offset: offset, extended: true, completion: { (response, error) in
            if let response = response?.response {
                let wrapped = self.wrapDialogs(response)
                DispatchQueue.main.async {
                    completion(wrapped, nil)
                }
            }
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        })
    }
    
    
    private func wrapMessages(response: VKGetHistoryResponse) -> [VKMessageWrapper] {
        var wrapped = [VKMessageWrapper]()
        for message in response.items {
            wrapped.append(wrapMessage(message, profiles: response.profiles, groups: response.groups))
        }
        return wrapped
    }
    
    
    private func wrapMessage(_ msg: VKMessageModel, profiles: [VKProfile]?, groups: [VKGroup]?) -> VKMessageWrapper {
        let profile = findProfileById(id: msg.fromId, in: profiles)
        let group = findGroupById(id: -msg.fromId, in: groups)
        
        var wrappedForwarded = [VKMessageWrapper]()
        if let forwarded = msg.fwdMessages {
            for fwd in forwarded {
                let wrapped = wrapMessage(fwd, profiles: profiles, groups: groups)
                wrappedForwarded.append(wrapped)
            }
        }
        
        let wrapper = VKMessageWrapper.init(message: msg, profile: profile, group: group, forwardedMessages: wrappedForwarded)
        return wrapper
    }
    
    
    private func wrapDialogs(_ response: VKGetConversationsResponse) -> [VKDialogWrapper] {
        var wrapped = [VKDialogWrapper]()
        for item in response.items {
            wrapped.append(wrapDialog(item, profiles: response.profiles, groups: response.groups))
        }
        return wrapped
    }
    
    
    private func wrapDialog(_ item: VKGetConversationsResponse.Item, profiles: [VKProfile]?, groups: [VKGroup]?) -> VKDialogWrapper {
        let profile = findProfileById(id: item.conversation.peer.localId, in: profiles)
        let group = findGroupById(id: item.conversation.peer.localId, in: groups)
        let lastMessage = wrapMessage(item.lastMessage, profiles: profiles, groups: groups)
        
        return VKDialogWrapper.init(dialog: item.conversation, profile: profile, group: group, lastMessage: lastMessage)
    }
    
    
    private func findProfileById(id: Int, in profiles: [VKProfile]?) -> VKProfile? {
        guard let profiles = profiles else { return nil }
        
        for profile in profiles {
            if profile.id == id {
                return profile
            }
        }
        
        return nil
    }
    
    
    private func findGroupById(id: Int, in groups: [VKGroup]?) -> VKGroup? {
        guard let groups = groups else { return nil }
        
        for group in groups {
            if group.id == id {
                return group
            }
        }
        
        return nil
    }
}
