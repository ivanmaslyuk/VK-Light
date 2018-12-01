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
    private var updateHandler = VKLongPollEventHandler.shared
    
    private init() { }
    
    
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
    
    
    private func getServer(blocking: Bool, finished: @escaping () -> Void = {}) {
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            let response = VKMessagesApi().getLongPollServer()?.response
            print(response as Any)
            self.server = response
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
            getServer(blocking: true)
            return
        }
        
        let response = VKLongPollApi().waitForLongPollUpdates(server: server.server, key: server.key, ts: self.newTs ?? server.ts)
        if let response = response {
            if let ts = response.ts { self.newTs = ts }
            if let error = response.failed {
                print("LP-сервер прислал ошибку: \(error)")
                if error != 1 {
                    getServer(blocking: true)
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
