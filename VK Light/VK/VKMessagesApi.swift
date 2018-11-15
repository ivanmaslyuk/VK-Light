//
//  VKMessagesApi.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKMessagesApi {
    
    func getConversations(count : Int, offset : Int = 0, extended: Bool = false) -> VKResponse<VKGetConversationsResponse>? {
        
        // проверить входные данные и кинуть исключения если что
        if count >= 200 {
            print("так низя")
        }
        
        let propertioes : Dictionary<String, String> = [
            "count" : String(count),
            "offset" : String(offset),
            "extended" : extended ? "1" : "0"
        ]
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let vkResponse = VKHttpRequestLayer.getResponse(methodName: "messages.getConversations", parameters: propertioes)
        let data = vkResponse.data(using: .utf8)!
        
        do {
            return try decoder.decode(VKResponse<VKGetConversationsResponse>.self, from: data)
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
}
