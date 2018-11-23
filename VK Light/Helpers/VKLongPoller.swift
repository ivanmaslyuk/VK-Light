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
    private var newMessageHandlers : [(Message) -> Void] = []
    private let userDefaults = UserDefaults.standard
    
    private init(){
        
    }
    
    private func getServer(finished: @escaping () -> Void) {
        DispatchQueue.global().async {
            self.server = VKMessagesApi().getLongPollServer()?.response
            DispatchQueue.main.async {
                print("получен LP-сервер")
                finished()
            }
        }
    }
    
    func prepareAnd(finished: @escaping () -> Void) {
        getServer(finished: finished)
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
    
    func doLongPollRequest() {
        guard let server = self.server else {
            print("doLongPollRequest() был вызван до инициализации self.server")
            getServer { return }
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
                
                if let ts = response?.ts {
                    self.ts = ts
                    if let errorCode = response?.failed {
                        if errorCode != 1 {
                            self.getServer { return }
                        }
                    }
                    if let updates = response?.updates {
                        self.handleUpdates(updates: updates)
                    }
                }
                else {
                    self.getServer { return }
                }
            }
            sema.signal()
        }.resume()
        sema.wait()
    }
    
    func decodeResponse(data: Data) -> VKLPResponse? {
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
    }
    
    func handleUpdates(updates: [VKLPHistoryItemModel]) {
        for update in updates {
            switch update.kind {
            case .newMessage:
                notifyNewMessage(message: Message(peerId: update.peerId!, text: update.messageText ?? "", sticker: nil, profile: nil, group: nil, isFromMe: update.messageFlags!.isOutbox))
            default:
                continue
            }
        }
    }
    
    func addNewMessageHandler(handler: @escaping (_ message: Message) -> Void) {
        self.newMessageHandlers.append(handler)
    }
    
    private func notifyNewMessage(message: Message) {
        for handler in newMessageHandlers {
            DispatchQueue.main.async {
                handler(message)
            }
        }
    }
    
}
