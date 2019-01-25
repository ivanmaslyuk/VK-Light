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
    
    func getConversations(count: Int, offset: Int = 0, extended: Bool = false, fields: [String] = ["online", "photo_100", "photo_50", "photo_200"], completion: @escaping VKResponseHandler<VKGetConversationsResponse>) {
        
        // проверить входные данные и кинуть исключения если что
        if count >= 200 {
            print("так низя")
        }
        
        let propertioes : Dictionary<String, String> = [
            "count" : String(count),
            "offset" : String(offset),
            "extended" : extended ? "1" : "0",
            "fields" : fields.joined(separator: ",")
        ]
        
        return requestLayer.getResponse(method: "messages.getConversations", parameters: propertioes, completion: completion)
    }
    
    func getHistory(peerId: Int, startMessageId: Int, count: Int = 20, offset: Int = 0, extended: Bool = false, reverse: Bool = false, fields: [String] = ["online", "photo_100", "photo_50", "photo_200"], completion: @escaping VKResponseHandler<VKGetHistoryResponse>) {
        let parameters : Dictionary<String, String> = [
            "peer_id" : String(peerId),
            "start_message_id" : String(startMessageId),
            "count" : String(count),
            "offset" : String(offset),
            "rev" : reverse ? "1" : "0",
            "extended" : extended ? "1" : "0",
            "fields" : fields.joined(separator: ",")
        ]
        
        return requestLayer.getResponse(method: "messages.getHistory", parameters: parameters, completion: completion)
    }
    
    func getLongPollServer(completion: @escaping VKResponseHandler<VKLPServerModel>) {
        let parameters: Dictionary<String, String> = [
            "need_pts" : "1",
            "lp_version" : "3"
        ]
        
        return requestLayer.getResponse(method: "messages.getLongPollServer", parameters: parameters, completion: completion)
    }
    
    /*func getLongPollHistory(ts: Int, pts: Int, onlines: Bool, fields: [String]) -> VKResponse<VKGetLongPollHistoryResponse>? {
        let parameters : [String : String] = [
            "ts" : String(ts),
            "pts" : String(pts),
            "onlines" : onlines ? "1" : "0",
            "fields" : fields.joined(separator: ","),
            "lp_version" : "3"
            ]
        
        return requestLayer.getResponse(methodName: "messages.getLongPollHistory", parameters: parameters)
    }*/
    
    
    func getById(ids: [Int], extended: Bool, fields: [String] = ["online", "photo_100", "photo_50", "photo_200"], completion: @escaping VKResponseHandler<VKGetMessagesByIdResponse>) {
        var ids_str: [String] = []
        for id in ids { ids_str.append(String(id)) }
        
        let parameters: [String : String] = [
            "message_ids" : ids_str.joined(separator: ","),
            "extended" : extended ? "1" : "0",
            "fields" : fields.joined(separator: ",")
        ]
        
        return requestLayer.getResponse(method: "messages.getById", parameters: parameters, completion: completion)
    }
    
    
    
}
