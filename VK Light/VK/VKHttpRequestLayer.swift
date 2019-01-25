//
//  VKHttpRequestLayer.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation


enum RequestFailureReason : String {
    case connectionError
    case couldNotDecode
}

typealias VKResponseHandler<T: Decodable> = (VKResponse<T>?, RequestFailureReason?) -> Void


class VKHttpRequestLayer {
    
    
    var accessToken : String = ""
    let version : String = "5.92"
    
    init() {
        self.accessToken = UserDefaults.standard.value(forKey: "vk_token") as! String
    }
    
    
    func getResponse<T : Decodable>(method: String, parameters: [String:String], completion: @escaping VKResponseHandler<T>) {
        var params = parameters
        params["access_token"] = accessToken
        params["v"] = version
        let paramsString = params.map{ "\($0)=\($1)" }.joined(separator: "&")
        
        let url = URL(string: "https://api.vk.com/method/\(method)?\(paramsString)")!
        print(url)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                completion(nil, .connectionError)
            }
            if let data = data {
                let decoder = self.getJsonDecoder()
                do {
                    let decoded = try decoder.decode(VKResponse<T>.self, from: data)
                    completion(decoded, nil)
                }
                catch let error {
                    print(error)
                    completion(nil, .couldNotDecode)
                }
            }
        }.resume()
    }
    
    
    private func decodeResponse<T: Decodable>(_ data: Data) -> VKResponse<T>? {
        let decoder = getJsonDecoder()
        do {
            return try decoder.decode(VKResponse<T>.self, from: data)
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    
    private func getJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        return decoder
    }
    
    
}
