//
//  DynamicDataContainer.swift
//  VK Light
//
//  Created by Иван Маслюк on 23/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class DynamicDataContainer {
    static let shared = DynamicDataContainer()
    
    typealias DialogsHandler = ([Dialog]) -> Void
    private var dialogsHandler: DialogsHandler?
    private var messagesHandlers: [MessagesHandler] = []
    private var onlinesHandlers: [OnlineStatusHandler] = []
    private var dialogs: [Dialog] = []
    
    private init() {
        fetchDataFromDataBase()
    }
    
    func subscribeForDialogs(handler: @escaping DialogsHandler) {
        self.dialogsHandler = handler
    }
    
    func unsubscribeFromDialogs() {
        self.dialogsHandler = nil
    }
    
    func subscribeForMessages(peerId: Int, handler: @escaping ([Message]) -> Void) {
        self.messagesHandlers.append(MessagesHandler(peerId: peerId, handler: handler))
    }
    
    func unsubscribeFromMessages(peerId: Int) {
        for i in 0...(messagesHandlers.count - 1) {
            if messagesHandlers[i].peerId == peerId {
                messagesHandlers.remove(at: i)
                return
            }
        }
    }
    
    func subscribeForOnlines(userId: Int, handler: @escaping (Bool) -> Void) {
        self.onlinesHandlers.append(OnlineStatusHandler(userId: userId, handler: handler))
    }
    
    func unsubscribeFromOnlines(userId: Int) {
        for i in 0...(onlinesHandlers.count - 1) {
            if onlinesHandlers[i].userId == userId {
                messagesHandlers.remove(at: i)
                return
            }
        }
    }
    
    func loadMoreMessages(peerId: Int) {
        DispatchQueue.global().async {
            guard let dialog = self.getDialog(peerId: peerId) else {
                print("loadMoreMessages: не существует диалога в локальном доступе с таким peerId")
                return
            }
            
            //let response = VKMessagesApi().getHistory(peerId: <#T##Int#>, startMessageId: <#T##Int#>, count: <#T##Int#>, offset: <#T##Int#>, extended: true)
        }
    }
    
    private func getDialog(peerId: Int) -> Dialog? {
        for dialog in dialogs {
            if dialog.peerId == peerId {
                return dialog
            }
        }
        return nil
    }
    
    private func fetchDataFromDataBase() {
        
    }
    
}

struct MessagesHandler {
    let peerId: Int
    let handler: ([Message]) -> Void
}

struct OnlineStatusHandler {
    let userId: Int
    let handler: (Bool) -> Void
}
