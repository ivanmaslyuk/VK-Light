//
//  VKLongPollEventHandler.swift
//  VK Light
//
//  Created by Иван Маслюк on 01/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKLongPollEventHandler {
    
    static let shared = VKLongPollEventHandler()
    private var newMessageHandlers : [(VKMessageWrapper) -> Void] = []
    
    private init() {}
    
    
    func handle(updates: [VKLPHistoryItemModel]) {
        var messageIds: [Int] = []
        for update in updates {
            print("LongPoller: Произошло событие \(update.kind) (\(update.kind.rawValue))")
            switch update.kind {
            case .newMessage:
                messageIds.append(update.messageId!)
            default:
                continue
            }
        }
        if !messageIds.isEmpty { handleNewMessages(ids: messageIds) }
    }
    
    
    private func handleNewMessages(ids: [Int]) {
        let vkResponse = VKMessagesApi().getById(ids: ids, extended: true)
        guard let response = vkResponse?.response else {return}
        
        for message in response.items {
            let relatedProfile = response.findProfileById(id: message.peerId!)
            let relatedGroup = response.findGroupById(id: -message.peerId!)
            notifyNewMessage(message: VKMessageWrapper(message: message, profile: relatedProfile, group: relatedGroup))
        }
    }
    
    
    private func handleUserIsTyping(peerId: Int) {
        
    }
    
    
    private func handleUserIsTypingInChat(userId: Int, chatId: Int) {
        
    }
    
    
    
    
    
    func addNewMessageHandler(handler: @escaping (_ message: VKMessageWrapper) -> Void) {
        self.newMessageHandlers.append(handler)
    }
    
    
    private func notifyNewMessage(message: VKMessageWrapper) {
        for handler in newMessageHandlers {
            DispatchQueue.main.async {
                handler(message)
            }
        }
    }
    
    
}
