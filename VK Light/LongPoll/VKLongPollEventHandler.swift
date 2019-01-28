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
//        print("LongPoller: ПОЛУЧЕНЫ ДАННЫЕ ОТ LP")
        var messageIds: [Int] = []
        var editedMsgIds: [Int] = []
        var flagsSetForMessages = [VKLPHistoryItemModel]()
        for update in updates {
//            print("LongPoller: Произошло событие \(update.kind) (\(update.kind.rawValue))")
            switch update.kind {
            case .messageFlagsSet, .messageFlagsReset, .messageFlagsChanged:
                //notifyMessageFlagsChanged(peerId: update.peerId!, messageId: update.messageId!, flags: update.messageFlags!)
                if !messageIds.isEmpty {
                    handleNewMessages(ids: messageIds)
                    messageIds.removeAll()
                }
                flagsSetForMessages.append(update)
            case .newMessage:
                messageIds.append(update.messageId!)
            case .messageEdited:
                editedMsgIds.append(update.messageId!)
            case .friendWentOnline:
                notifyOnlineChanged(userId: update.userId!, status: true)
            case .friendWentOffline:
                notifyOnlineChanged(userId: update.userId!, status: false)
            case .incomingMessagesRead:
                notifyMessagesRead(peerId: update.peerId!, localId: update.localId!, sent: false)
            case .sentMessagesRead:
                notifyMessagesRead(peerId: update.peerId!, localId: update.localId!, sent: true)
            case .userIsTyping:
                notifyUserIsTyping(userId: update.userId!)
            case .counterInLeftMenuChanged:
                notifyMenuCounterChanged(newCount: update.count!)
            case .userIsTypingInChat:
                notifyTypingInChat(userId: update.userId!, chatId: update.chatId!)
            case .notificationPreferencesChanged:
                notifyNotificationSettingsChanged(peerId: update.peerId!, soundEnabled: update.soundEnabled!, disabledUntil: update.disabledUntil!)
            default:
                continue
            }
        }
        if !messageIds.isEmpty { handleNewMessages(ids: messageIds) }
        if !editedMsgIds.isEmpty { handleEditedMessages(ids: editedMsgIds) }
        if !flagsSetForMessages.isEmpty { handleFlags(flagsSetForMessages) }
    }
    
    
    
    
    
    /******************* НОВЫЕ СООБЩЕНИЯ **********************/
    private var newMessageSubscribers: [NewMessagesSubscriber] = []
    
    private func handleNewMessages(ids: [Int]) {
        VKMessagesApi().getById(ids: ids, extended: true, completion: { (response, error) in
            guard let response = response?.response else {return}
            
            for message in response.items {
                let relatedProfile = response.findProfileById(id: message.fromId)
                let relatedGroup = response.findGroupById(id: -message.fromId)
                self.notifyNewMessage(message: VKMessageWrapper(message: message, profile: relatedProfile, group: relatedGroup, forwardedMessages: [])) // TODO: добавить поддержку пересланных
            }
        })
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
    
    
    
    /******************* РЕДАКТИРОВАНИЕ СООБЩЕНИЯ **********************/
    private var messageEditSubscribers: [MessageEditedSubscriber] = []
    
    func addMessageEditedSubscriber(subscriber: MessageEditedSubscriber) {
        messageEditSubscribers.append(subscriber)
    }
    
    func removeMessageEditedSubscriber(subscriber toRemove: MessageEditedSubscriber) {
        messageEditSubscribers.removeAll(where: {$0 === toRemove})
    }
    
    private func handleEditedMessages(ids: [Int]) {
        VKMessagesApi().getById(ids: ids, extended: true, completion: {(response, error) in
            guard let response = response?.response else {return}
            
            for message in response.items {
                let relatedProfile = response.findProfileById(id: message.peerId!)
                let relatedGroup = response.findGroupById(id: -message.peerId!)
                self.notifyMessageEdited(message: VKMessageWrapper(message: message, profile: relatedProfile, group: relatedGroup, forwardedMessages: [])) //FIXME: исправить
            }
        })
    }
    
    private func notifyMessageEdited(message: VKMessageWrapper) {
        for sub in messageEditSubscribers {
            if sub.watchesMessageEditsForPeer() == message.message.peerId || sub.watchesMessageEditsForAllPeers() {
                DispatchQueue.main.async {
                    sub.messageWasEdited(editedMessage: message)
                }
            }
        }
    }
    
    
    
    /******************* ПРОЧТЕНИЕ ВХОДЯЩИХ/ИСХОДЯЩИХ СООБЩЕНИЙ **********************/
    private var messagesReadSubscribers: [MessagesReadSubscriber] = []
    
    func addMessagesReadSubscriber(subscriber: MessagesReadSubscriber) {
        messagesReadSubscribers.append(subscriber)
    }
    
    func removeMessagesReadSubscriber(subscriber: MessagesReadSubscriber) {
        messagesReadSubscribers.removeAll(where: {$0 === subscriber})
    }
    
    private func notifyMessagesRead(peerId: Int, localId: Int, sent: Bool) {
        for sub in messagesReadSubscribers {
            if sub.watchesMessagesReadForPeer() == peerId || sub.watchesMessagesReadForAllPeers() {
                DispatchQueue.main.async {
                    sub.messagesRead(peerId: peerId, localId: localId, sent: sent)
                }
            }
        }
    }
    
    
    
    /******************* ИЗМЕНЕНИЕ СЧЕТЧИКА В ЛЕВОМ МЕНЮ **********************/
    private var menuCounterSubscribers: [MenuCounterSubscriber] = []
    
    func addMenuCounterSubscriber(subscriber: MenuCounterSubscriber) {
        menuCounterSubscribers.append(subscriber)
    }
    
    func removeMenuCounterSubscriber(subscriber: MenuCounterSubscriber) {
        menuCounterSubscribers.removeAll(where: {$0 === subscriber})
    }
    
    private func notifyMenuCounterChanged(newCount: Int) {
        for sub in menuCounterSubscribers {
            DispatchQueue.main.async {
                sub.counterChanged(newCount: newCount)
            }
        }
    }
    
    
    
    /******************* ИЗМЕНИЛИСЬ ФЛАГИ СООБЩЕНИЯ **********************/
    private var messageFlagsSubscribers: [MessageFlagsSubscriber] = []
    
    func handleFlags(_ flags: [VKLPHistoryItemModel]) {
        var peerDict = [Int : [MessageIdAndFlags]]()
        for elem in flags {
            peerDict[elem.peerId!] = [MessageIdAndFlags]()
        }
        for elem in flags {
            peerDict[elem.peerId!]!.append(MessageIdAndFlags(messageId: elem.messageId!, flags: elem.messageFlags!))
        }
        for key in peerDict.keys {
            notifyMessageFlagsChanged(peerId: key, messages: peerDict[key]!)
        }
    }
    
    func addMessageFlagsSubscriber(subscriber: MessageFlagsSubscriber) {
        messageFlagsSubscribers.append(subscriber)
    }
    
    func removeMessageFlagsSubscriber(subscriber: MessageFlagsSubscriber) {
        messageFlagsSubscribers.removeAll(where: {$0 === subscriber})
    }
    
    private func notifyMessageFlagsChanged(peerId: Int, messages: [MessageIdAndFlags]) {
        for sub in messageFlagsSubscribers {
            if sub.watchesMessageFlagsForPeer() == peerId || sub.watchesMessageFlagsForAllPeers() {
                DispatchQueue.main.async {
                    sub.messageFlagsChanged(peerId: peerId, messages: messages)
                }
            }
        }
    }
    
    
    
    /******************* ИЗМЕНИЛИСЬ НАСТРОЙКИ ЗВУКОВЫХ ОПОВЕЩЕНИЙ **********************/
    private var notificationSettingsSubscribers: [NotificationSettingsSubscriber] = []
    
    func addNotificationSettingsSubscriber(subscriber: NotificationSettingsSubscriber) {
        notificationSettingsSubscribers.append(subscriber)
    }
    
    func removeNotificationSettingsSubscriber(subscriber: NotificationSettingsSubscriber) {
        notificationSettingsSubscribers.removeAll(where: {$0 === subscriber})
    }
    
    private func notifyNotificationSettingsChanged(peerId: Int, soundEnabled: Bool, disabledUntil: Int) {
        for sub in notificationSettingsSubscribers {
            if sub.watchesNotificationSettingsForPeer() == peerId || sub.watchesNotificationSettingsForAllPeers() {
                DispatchQueue.main.async {
                    sub.notificationSettingsChanged(peerId: peerId, soundEnabled: soundEnabled, disabledUntil: disabledUntil, disabledForever: disabledUntil == -1)
                }
            }
        }
    }
    
    
    
    
}
