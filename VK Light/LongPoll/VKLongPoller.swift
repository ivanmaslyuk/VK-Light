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
    var statusSubscribers = [LPStatusSubscriber]()
    private init() { }
    
    
    /*func prepareAnd(finished: @escaping () -> Void) {
        getServer(blocking: false, finished: finished)
    }*/
    
    
    func resume() {
        /*guard let _ = self.server else {
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
        }*/
        
        if isPaused {
            if server == nil || ts == nil || key == nil {
                getServer()
            }
            isPaused = false
            print("Работа LongPoller возобновлена")
            DispatchQueue.global().async {
                while true {
                    if !self.isPaused {
                        self.doLongPollRequest()
                    } else {
                        break
                    }
                }
            }
        }
    }
    
    
    func pause() {
        isPaused = true
        print("LongPoller приостановлен")
    }
    
    
    
    private func getServer() {
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            VKMessagesApi().getLongPollServer(completion: { (response, error) in
                if let response = response?.response {
                    self.server = response.server
                    self.ts = response.ts
                    self.key = response.key
                }
                if let error = error {
                    print(error)
                }
                sema.signal()
            })
        }
        sema.wait()
    }
    
    
    private func doLongPollRequest() {
        guard let server = self.server, let key = self.key, let ts = self.ts else {
            print("doLongPollRequest() был вызван до инициализации self.server. LongPoller будет остановлен. Значения: ts: \(String(describing: self.ts)), server: \(String(describing: self.server)), key: \(String(describing: self.key))")
            //getServer()
            isPaused = true
            return
        }
        
        let response = longPollApi.waitForLongPollUpdates(server: server, key: key, ts: ts)
        if let response = response {
            if let ts = response.ts { self.ts = ts }
            if let error = response.failed {
                print("LP-сервер прислал ошибку: \(error)")
                if error != 1 {
                    getServer()
                    DispatchQueue.main.async {
                        self.notifyStatusChanged(status: .error)
                    }
                }
            }
            if let updates = response.updates {
                DispatchQueue.main.async {
                    self.notifyStatusChanged(status: .ok)
                }
                updateHandler.handle(updates: updates)
            }
        } else {
            print("Не удалось раскодировать ответ LongPoll-сервера.")
        }
    }
    
    
    func addStatusSubscriber(_ sub: LPStatusSubscriber) {
        statusSubscribers.append(sub)
    }
    
    
    func removeStatusSubscriber(_ sub: LPStatusSubscriber) {
        statusSubscribers = statusSubscribers.filter({$0 !== sub})
    }
    
    
    func notifyStatusChanged(status: LPStatus) {
        for sub in statusSubscribers {
            sub.lpStatusChanged(status)
        }
    }
    
}
