//
//  DialogsHelper.swift
//  VK Light
//
//  Created by Иван Маслюк on 24/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class DialogsHelper {
    
    /*func getDialogs(count: Int, offset: Int = 0) -> [Dialog]? {
        guard let response = VKMessagesApi().getConversations(count: count, offset: offset, extended: true)?.response else {return nil}
        
        var result: [Dialog] = []
        for conversation in response.items {
            let title = extractDialogTitle(item: conversation, response: response)
            let peerType = conversation.conversation.peer.type
            let peerId = conversation.conversation.peer.id
            let unreadCount = conversation.conversation.unreadCount
            
            let profile = response.findProfileById(id: conversation.lastMessage.fromId)
            let group = response.findGroupById(id: -conversation.lastMessage.fromId)
            let lastMessageConverted = MessageHelper.translateVKMessage(model: conversation.lastMessage, associatedProfile: profile, associatedGroup: group)
            let messages: [Message] = [lastMessageConverted]
            
            result.append(Dialog(title: title, peerType: peerType, peerId: peerId, unreadCount: unreadCount, messages: messages))
        }
        return result
    }*/
    
    private func extractDialogTitle(item: VKGetConversationsResponse.Item, response: VKGetConversationsResponse) -> String {
        let peerId = item.conversation.peer.id
        
        switch item.conversation.peer.type {
        case .user:
            guard let profile = response.findProfileById(id: peerId) else {return "Неизвестно"}
            return profile.firstName + " " + profile.lastName
        case .chat:
            guard let chat = item.conversation.chatSettings else {return "Неизвестно"}
            return chat.title
        case .group:
            guard let group = response.findGroupById(id: -peerId) else {return "Неизвестно"}
            return group.name
        case .email:
            return "ЧАТ С EMAIL"
        }
    }
    
}
