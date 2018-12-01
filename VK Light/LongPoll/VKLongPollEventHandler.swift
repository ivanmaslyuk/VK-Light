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
                notifyUserIsTyping(userId: update.userId!)
            case .userIsTypingInChat:
                notifyTypingInChat(userId: update.userId!, chatId: update.chatId!)
            default:
                continue
            }
        }
        if !messageIds.isEmpty { handleNewMessages(ids: messageIds) }
    }
    
    
    
    /******************* НОВЫЕ СООБЩЕНИЯ **********************/
    private var newMessageSubscribers: [NewMessagesSubscriber] = []
    
    private func handleNewMessages(ids: [Int]) {
        let vkResponse = VKMessagesApi().getById(ids: ids, extended: true)
        guard let response = vkResponse?.response else {return}
        
        for message in response.items {
            let relatedProfile = response.findProfileById(id: message.peerId!)
            let relatedGroup = response.findGroupById(id: -message.peerId!)
            notifyNewMessage(message: VKMessageWrapper(message: message, profile: relatedProfile, group: relatedGroup))
        }
    }
    
    func addNewMessageSubscriber(subscriber: NewMessagesSubscriber) {
        newMessageSubscribers.append(subscriber)
        print("Добавлен подписчик на сообщения: \(newMessageSubscribers.count)")
    }
    
    func removeNewMessageSubscriber(subscriber toRemove: NewMessagesSubscriber) {
        newMessageSubscribers.removeAll(where: {subscriber in return subscriber === toRemove})
        print("Удален подписчик на сообщения: \(newMessageSubscribers.count)")
    }
    
    private func notifyNewMessage(message: VKMessageWrapper) {
        for subscriber in newMessageSubscribers {
            if subscriber.peerWatchedForMessages == message.message.peerId || subscriber.watchesAllMessages {
                DispatchQueue.main.async {
                    subscriber.newMessageReceived(message: message)
                }
            }
        }
    }
    
    
    
    /******************* НАБОР СООБЩЕНИЯ **********************/
    /*typealias typingHandler = () -> Void
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
    }*/
    private var typingSubscribers: [UserTypingSubscriber] = []
    
    func addTypingSubscriber(subscriber: UserTypingSubscriber) {
        typingSubscribers.append(subscriber)
    }
    
    func removeTypingSubscriber(subscriber toRemove: UserTypingSubscriber) {
        typingSubscribers.removeAll(where: {subscriber in return subscriber === toRemove})
    }
    
    func notifyUserIsTyping(userId: Int) {
        for subscriber in typingSubscribers {
            if subscriber.watchingTypingFromUser() == userId || subscriber.watchesTypingFromAllUsers() {
                DispatchQueue.main.async {
                    subscriber.userStartedTyping(userId: userId)
                }
            }
        }
    }
    
    
    
    /******************* НАБОР СООБЩЕНИЯ В ЧАТЕ **********************/
    /*typealias typingInChatHandler = (Int) -> Void
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
    }*/
    private var typingInChatSubscribers: Array<TypingInChatSubscriber> = []
    
    func addTypingInChatSubscriber(subscriber: TypingInChatSubscriber) {
        typingInChatSubscribers.append(subscriber)
    }
    
    func removeTypingInChatSubscriber(subscriber toRemove: TypingInChatSubscriber) {
        typingInChatSubscribers.removeAll(where: {sub in return sub === toRemove})
    }
    
    private func notifyTypingInChat(userId: Int, chatId: Int) {
        for subscriber in typingInChatSubscribers {
            if subscriber.watchingTypingInChat() == chatId || subscriber.watchesTypingFromAllChats() {
                DispatchQueue.main.async {
                    subscriber.userStartedTypingInChat(userId: userId, chatId: chatId)
                }
            }
        }
    }
    
    
    
    /******************* ИЗМЕНЕНИЕ СТАТУСА ОНЛАЙН **********************/
    private var onlineSubscibers: [OnlinesSubscriber] = []
    
    func addOnlinesSubscriber(subscriber: OnlinesSubscriber) {
        onlineSubscibers.append(subscriber)
        print("Добавлен подписчик на онлайны: \(onlineSubscibers.count)")
    }
    
    func removeOnlinesSubscriber(subscriber toRemove: OnlinesSubscriber) {
        onlineSubscibers.removeAll(where: {subscriber in return subscriber === toRemove})
        print("Удален подписчик на онлайны: \(onlineSubscibers.count)")
    }
    
    private func notifyOnlineChanged(userId: Int, status: Bool) {
        for subscriber in onlineSubscibers {
            if subscriber.watchedOnlines.contains(userId) || subscriber.watchesAllOnlines {
                DispatchQueue.main.async {
                    subscriber.onlineStatusChanged(for: userId, status: status)
                }
            }
        }
    }
    
}
