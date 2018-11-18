//
//  VKMessagesApi.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKMessagesApi {
    
    func getConversations(count: Int, offset: Int = 0, extended: Bool = false) -> VKResponse<VKGetConversationsResponse>? {
        
        // проверить входные данные и кинуть исключения если что
        if count >= 200 {
            print("так низя")
        }
        
        let propertioes : Dictionary<String, String> = [
            "count" : String(count),
            "offset" : String(offset),
            "extended" : extended ? "1" : "0"
        ]
        
        let requestLayer = VKHttpRequestLayer()
        return requestLayer.getResponse(methodName: "messages.getConversations", parameters: propertioes)
    }
    
    func getHistory(peerId: Int, startMessageId: Int, count: Int = 20, offset: Int = 0) -> VKResponse<VKGetHistoryResponse>? {
        let parameters : Dictionary<String, String> = [
            "peer_id" : String(peerId),
            "start_message_id" : String(startMessageId),
            "count" : String(count),
            "offset" : String(offset)
        ]
        
        let requestLayer = VKHttpRequestLayer()
        return requestLayer.getResponse(methodName: "messages.getHistory", parameters: parameters)
    }
    
}
