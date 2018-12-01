//
//  VKLongPoller.swift
//  VK Light
//
//  Created by Иван Маслюк on 20/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKLongPoller {
    
    static var shared = VKLongPoller()
    private var server: VKLPServerModel?
    private var newTs: Int?
    private var newMessageHandlers : [(VKMessageWrapper) -> Void] = []
    
    
    private init(){
        
    }
    
    
    func prepareAnd(finished: @escaping () -> Void) {
        getServer(blocking: false, finished: finished)
    }
    
    
    func startLongPolling() {
        guard let _ = self.server else {
            print("Невозможно начать LongPoll-запрос, так как self.server не инициализирован.")
            return
        }
        
        DispatchQueue.global().async {
            while (true) {
                self.doLongPollRequest()
            }
        }
    }
    
    
    private func getServer(blocking: Bool, finished: @escaping () -> Void) {
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            self.server = VKMessagesApi().getLongPollServer()?.response
            DispatchQueue.main.async {
                print("получен LP-сервер")
                if blocking { sema.signal() }
                finished()
            }
        }
        if blocking { sema.wait() }
    }
    
    
    func doLongPollRequest() {
        guard let server = self.server else {
            print("doLongPollRequest() был вызван до инициализации self.server")
            getServer(blocking: true) { return }
            return
        }
        
        let response = VKLongPollApi().waitForLongPollUpdates(server: server.server, key: server.key, ts: self.newTs ?? server.ts)
        if let response = response {
            if let ts = response.ts { self.newTs = ts }
            if let error = response.failed {
                print("LP-сервер прислал ошибку: \(error)")
                if error != 1 {
                    getServer(blocking: true, finished: {})
                }
            }
            if let updates = response.updates {
                handleUpdates(updates: updates)
            }
        } else {
            print("Полученный ответ от LP-сервера не является корректным.")
        }
    }
    
    
    private func handleUpdates(updates: [VKLPHistoryItemModel]) {
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
