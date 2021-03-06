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
    
    private init() {}
    
    
    func handle(updates: [VKLPHistoryItemModel]) {
        var messageIds: [Int] = []
        for update in updates {
            print("LongPoller: Произошло событие \(update.kind) (\(update.kind.rawValue))")
            switch update.kind {
            case .newMessage:
                messageIds.append(update.messageId!)
            case .friendWentOnline:
                notifyOnlineChanged(userId: update.userId!, status: true)
            case .friendWentOffline:
                notifyOnlineChanged(userId: update.userId!, status: false)
            case .userIsTyping:
                notifyUserIsTyping(peerId: update.userId!)
            case .userIsTypingInChat:
                notifyTypingInChat(userId: update.userId!, chatId: update.chatId!)
            default:
                continue
            }
        }
        if !messageIds.isEmpty { handleNewMessages(ids: messageIds) }
    }
    
    
    
    /******************* НОВЫЕ СООБЩЕНИЯ **********************/
    typealias newMessageHandler = (VKMessageWrapper) -> Void
    private var newMessageHandlers : Dictionary<Int, newMessageHandler> = [:]
    
    private func handleNewMessages(ids: [Int]) {
        let vkResponse = VKMessagesApi().getById(ids: ids, extended: true)
        guard let response = vkResponse?.response else {return}
        
        for message in response.items {
            let relatedProfile = response.findProfileById(id: message.peerId!)
            let relatedGroup = response.findGroupById(id: -message.peerId!)
            notifyNewMessage(message: VKMessageWrapper(message: message, profile: relatedProfile, group: relatedGroup))
        }
    }
    
    
    func addNewMessageHandler(peerId: Int, handler: @escaping newMessageHandler) {
        self.newMessageHandlers[peerId] = handler
    }
    
    func unsubscribeFromNewMessages() {
        
    }
    
    private func notifyNewMessage(message: VKMessageWrapper) {
        for handler in newMessageHandlers {
            if handler.key == message.message.peerId || handler.key == -1 {
                DispatchQueue.main.async {
                    handler.value(message)
                }
            }
        }
    }
    
    
    
    /******************* НАБОР СООБЩЕНИЯ **********************/
    typealias typingHandler = () -> Void
    private var typingHandlers: Dictionary<Int, typingHandler> = [:]
    
    func addTypingHandler(userId: Int, handler: @escaping typingHandler) {
        typingHandlers[userId] = handler
    }
    
    private func notifyUserIsTyping(peerId: Int) {
        for handler in typingHandlers {
            if handler.key == peerId || handler.key == -1 {
                DispatchQueue.main.async {
                    handler.value()
                }
            }
        }
    }
    
    
    
    /******************* НАБОР СООБЩЕНИЯ В ЧАТЕ **********************/
    typealias typingInChatHandler = (Int) -> Void
    private var typingInChatHandlers: Dictionary<Int, typingInChatHandler> = [:]
    
    func addTypingInChatHandler(chatId: Int, handler: @escaping typingInChatHandler) {
        typingInChatHandlers[chatId] = handler
    }
    
    private func notifyTypingInChat(userId: Int, chatId: Int) {
        for handler in typingInChatHandlers {
            if handler.key == chatId || handler.key == -1 {
                DispatchQueue.main.async {
                    handler.value(userId)
                }
            }
        }
    }
    
    
    
    /******************* ИЗМЕНЕНИЕ СТАТУСА ОНЛАЙН **********************/
    typealias onlineHandler = (Bool) -> Void
    private var onlineHandlers: Dictionary<[Int], onlineHandler> = [:]
    
    func addOnlineHandler(for user: [Int], handler: @escaping onlineHandler) {
        onlineHandlers[user] = handler
    }
    
    private func notifyOnlineChanged(userId: Int, status: Bool) {
        for handler in onlineHandlers {
            if handler.key.contains(userId) || handler.key.contains(-1) {
                DispatchQueue.main.async {
                    handler.value(status)
                }
            }
        }
    }
    
}
