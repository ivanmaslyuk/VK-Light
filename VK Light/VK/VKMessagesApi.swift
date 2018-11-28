//
//  VKMessagesApi.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

class VKMessagesApi {
    
    let requestLayer = VKHttpRequestLayer()
    
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
        
        return requestLayer.getResponse(methodName: "messages.getConversations", parameters: propertioes)
    }
    
    func getHistory(peerId: Int, startMessageId: Int, count: Int = 20, offset: Int = 0, extended: Bool = false, reverse: Bool = false) -> VKResponse<VKGetHistoryResponse>? {
        let parameters : Dictionary<String, String> = [
            "peer_id" : String(peerId),
            "start_message_id" : String(startMessageId),
            "count" : String(count),
            "offset" : String(offset),
            "rev" : reverse ? "1" : "0",
            "extended" : extended ? "1" : "0"
        ]
        
        return requestLayer.getResponse(methodName: "messages.getHistory", parameters: parameters)
    }
    
    func getLongPollServer() -> VKResponse<VKLPServerModel>? {
        let parameters: Dictionary<String, String> = [
            "need_pts" : "1",
            "lp_version" : "3"
        ]
        
        return requestLayer.getResponse(methodName: "messages.getLongPollServer", parameters: parameters)
    }
    
    func getLongPollHistory(ts: Int, pts: Int, onlines: Bool, fields: [String]) -> VKResponse<VKGetLongPollHistoryResponse>? {
        let parameters : [String : String] = [
            "ts" : String(ts),
            "pts" : String(pts),
            "onlines" : onlines ? "1" : "0",
            "fields" : fields.joined(separator: ","),
            "lp_version" : "3"
            ]
        
        return requestLayer.getResponse(methodName: "messages.getLongPollHistory", parameters: parameters)
    }
    
    
    func getById(ids: [Int], extended: Bool) -> VKResponse<VKGetMessagesByIdResponse>? {
        var ids_str: [String] = []
        for id in ids { ids_str.append(String(id)) }
        
        let parameters: [String : String] = [
            "message_ids" : ids_str.joined(separator: ","),
            "extended" : extended ? "1" : "0"
        ]
        
        return requestLayer.getResponse(methodName: "messages.getById", parameters: parameters)
    }
    
}
