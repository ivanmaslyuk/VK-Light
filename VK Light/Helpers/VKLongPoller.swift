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
    private var ts: Int?
    private var newPts: Int?
    private var newMessageHandlers : [(VKMessageWrapper) -> Void] = []
    //private let userDefaults = UserDefaults.standard
    
    private init(){
        
    }
    
    
    func prepareAnd(finished: @escaping () -> Void) {
        getServer(blocking: false, finished: finished)
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
    
    /*func doLongPollRequest() {
        guard let server = self.server else {
            print("doLongPollRequest() был вызван до инициализации self.server")
            getServer(blocking: true) { return }
            return
        }
        
        let request = URL(string: "https://\(server.server)?act=a_check&key=\(server.key)&ts=\(self.ts ?? server.ts)&wait=25&mode=2&version=3")!
        
        let sema = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("ошибка при попытке получить ответ от LP-сервера")
                print(error)
            }
            if let data = data {
                print("получен ответ от LP-сервера")
                print(String(data: data, encoding: .utf8) ?? "no data from lp server")
                let response = self.decodeResponse(data: data)
                self.handleLPResponse(response: response)
            }
            sema.signal()
        }.resume()
        sema.wait()
    }*/
    
    func doLongPollRequest() {
        guard let server = self.server else {
            print("doLongPollRequest() был вызван до инициализации self.server")
            getServer(blocking: true) { return }
            return
        }
        
        let response = VKMessagesApi().getLongPollHistory(ts: server.ts, pts: self.newPts ?? server.pts, onlines: true, fields: [])
        if let response = response?.response {
            self.handleLPResponse(response: response)
        } else {
            print("Полученный ответ от LP-сервера не является корректным.")
        }
        usleep(300000)
    }
    
    /*private func handleLPResponse(response: VKLPResponse?) {
        if let ts = response?.ts {
            self.ts = ts
            if let errorCode = response?.failed {
                if errorCode != 1 {
                    self.getServer(blocking: true) { return }
                }
            }
            if let updates = response?.updates {
                self.handleUpdates(updates: updates)
            }
        }
        else {
            self.getServer(blocking: true) { return }
        }
    }*/
    
    
    private func handleLPResponse(response: VKGetLongPollHistoryResponse) {
        self.newPts = response.newPts
        for update in response.history {
            print("Произошло событие: ", update.kind)
            
            var relatedMessage: VKMessageModel? = nil
            var relatedProfile: VKProfileModel? = nil
            var relatedGroup: VKGroupModel? = nil
            if let messageId = update.messageId {
                relatedMessage = response.findMessageById(id: messageId)
            }
            if let peerId = update.peerId {
                relatedProfile = response.findProfileById(id: peerId)
                relatedGroup = response.findGroupById(id: -peerId)
            }
            
            handleUpdate(update: update, relatedMessage: relatedMessage, relatedProfile: relatedProfile, relatedGroup: relatedGroup)
        }
    }
    
    
    private func handleUpdate(update: VKLPHistoryItemModel, relatedMessage: VKMessageModel?, relatedProfile: VKProfileModel?, relatedGroup: VKGroupModel?) {
        switch update.kind {
        case .newMessage:
            guard let message = relatedMessage else {return}
            let wrapped = VKMessageWrapper(message: message, profile: relatedProfile, group: relatedGroup)
            notifyNewMessage(message: wrapped)
        default:
            return
        }
    }
    
    
    /*func decodeResponse(data: Data) -> VKLPResponse? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            return try decoder.decode(VKLPResponse.self, from: data)
        }
        catch let error {
            print(error)
            return nil
        }
    }*/
    
    
    /*func handleUpdates(updates: [VKLPHistoryItemModel]) {
        for update in updates {
            switch update.kind {
            case .newMessage:
                notifyNewMessage(message: Message(peerId: update.peerId!, text: update.messageText ?? "", sticker: nil, senderName: "Неизвестно", isFromMe: update.messageFlags!.isOutbox))
            default:
                continue
            }
        }
    }*/
    
    
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
