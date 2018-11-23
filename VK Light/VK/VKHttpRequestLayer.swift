//
//  VKHttpRequestLayer.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKHttpRequestLayer {
    
    var accessToken : String = ""
    let version : String = "5.87"
    
    init() {
        self.accessToken = UserDefaults.standard.value(forKey: "vk_token") as! String
    }
    
    func getResponse<T : Decodable>(methodName: String, parameters: Dictionary<String, String>) -> VKResponse<T>? {
        
        var paramsAsString = ""
        for key in parameters.keys {
            paramsAsString.append("&" + key + "=" + parameters[key]!)
        }
        
        let url = URL(string: "https://api.vk.com/method/\(methodName)?\(paramsAsString)&access_token=\(accessToken)&v=\(version)")!
        print(url)
        
        return obtainResponse(url: url)
    }
    
    private func obtainResponse<T : Decodable>(url: URL) -> VKResponse<T>? {
        var vkResponse : String = ""
        let sema = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
            }
            if let data = data {
                vkResponse = String(data: data, encoding: .utf8) ?? ""
                
            }
            sema.signal()
        }.resume()
        sema.wait()
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        let data = vkResponse.data(using: .utf8)!
        do {
            return try decoder.decode(VKResponse<T>.self, from: data)
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    
    
}
