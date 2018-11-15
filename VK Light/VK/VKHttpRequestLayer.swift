//
//  VKHttpRequestLayer.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKHttpRequestLayer {
    
    static var accessToken : String = ""
    static let version : String = "5.87"
    
    static func getResponse(methodName: String, parameters: Dictionary<String, String>) -> String {
        
        var paramsAsString = ""
        for key in parameters.keys {
            paramsAsString.append("&")
            paramsAsString.append(key)
            paramsAsString.append("=")
            paramsAsString.append(parameters[key]!)
        }
        
        let r = "https://api.vk.com/method/\(methodName)?\(paramsAsString)&access_token=\(accessToken)&v=\(version)"
        let url = URL(string: r)!
        var vkResponse : String? = ""
        
        let session = URLSession.shared
        let sema = DispatchSemaphore( value: 0 )
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                vkResponse = String(data: data, encoding: .utf8)
                sema.signal()
            }
            
        }.resume()
        sema.wait()
        
        return vkResponse!
    }
}
