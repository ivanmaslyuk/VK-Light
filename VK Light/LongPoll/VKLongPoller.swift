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
    //private var server: VKLPServerModel?
    private var ts: Int?
    private var server: URL?
    private var key: String?
    private var updateHandler = VKLongPollEventHandler.shared
    private let longPollApi = VKLongPollApi()
    private var isPaused = true
    private init() { }
    
    
    func prepareAnd(finished: @escaping () -> Void) {
        getServer(blocking: false, finished: finished)
    }
    
    
    func resume() {
        guard let _ = self.server else {
            print("Невозможно начать LongPoll-запрос, так как self.server не инициализирован.")
            return
        }
        print("Работа LongPoller возобновлена")
        isPaused = false
        DispatchQueue.global().async {
            
            while (true) {
                if !self.isPaused {
                    self.doLongPollRequest()
                } else {
                    break
                }
            }
        }
    }
    
    
    func pause() {
        isPaused = true
        print("LongPoller приостановлен")
    }
    
    
    private func getServer(blocking: Bool, finished: @escaping () -> Void = {}) {
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            let response = VKMessagesApi().getLongPollServer()?.response
            print(response as Any)
            if let response = response {
                self.server = response.server
                self.ts = response.ts
                self.key = response.key
            }
            if blocking { sema.signal() }
            DispatchQueue.main.async {
                print("получен LP-сервер")
                
                finished()
            }
        }
        if blocking { sema.wait() }
    }
    
    
    private func doLongPollRequest() {
        guard let server = self.server, let key = self.key, let ts = self.ts else {
            print("doLongPollRequest() был вызван до инициализации self.server")
            getServer(blocking: true)
            return
        }
        
        let response = longPollApi.waitForLongPollUpdates(server: server, key: key, ts: ts)
        if let response = response {
            if let ts = response.ts { self.ts = ts }
            if let error = response.failed {
                print("LP-сервер прислал ошибку: \(error)")
                if error != 1 {
                    getServer(blocking: true)
                    NotificationDebugger.print(text: "ой")
                }
            }
            if let updates = response.updates {
                updateHandler.handle(updates: updates)
            }
        } else {
            print("Полученный ответ от LP-сервера не является корректным.")
        }
    }
    
    
    
}
