//
//  VKLongPollApi.swift
//  VK Light
//
//  Created by Иван Маслюк on 28/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKLongPollApi {
    
    
    func waitForLongPollUpdates(server: URL, key: String, ts: Int) -> VKLPResponse? {
        let request = URL(string: "https://\(server)?act=a_check&key=\(key)&ts=\(ts)&wait=25&mode=72&version=3")!
        
        var vkResponse: VKLPResponse? = nil
        
        let sema = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("ошибка при попытке получить ответ от LP-сервера")
                print(error)
            }
            if let data = data {
                //print("получен ответ от LP-сервера")
                //print(String(data: data, encoding: .utf8) ?? "no data from lp server")
                vkResponse = self.decodeResponse(data: data)
            }
            sema.signal()
        }.resume()
        sema.wait()
        
        return vkResponse
    }
    
    
    private func decodeResponse(data: Data) -> VKLPResponse? {
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
    
}
