//
//  VKGetLongPollHistoryResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 25/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGetLongPollHistoryResponse : Decodable {
    
    struct MessagesContainer : Decodable {
        let count: Int
        let items: [VKMessageModel]
    }
    
    let history: [VKLPHistoryItemModel]
    let messages: MessagesContainer?
    let newPts: Int
    let profiles : [VKProfileModel]?
    let groups : [VKGroupModel]?
    
    func findProfileById(id: Int) -> VKProfileModel? {
        guard let profiles = profiles else {return nil}
        
        for profile in profiles {
            if profile.id == id {
                return profile
            }
        }
        
        return nil
    }
    
    func findGroupById(id: Int) -> VKGroupModel? {
        guard let groups = groups else {return nil}
        
        for group in groups {
            if group.id == id {
                return group
            }
        }
        
        return nil
    }
    
    func findMessageById(id: Int) -> VKMessageModel? {
        guard let messages = messages else {return nil}
        
        for message in messages.items {
            if message.id == id {
                return message
            }
        }
        
        return nil
    }
    
    
}
