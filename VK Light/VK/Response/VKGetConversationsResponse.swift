//
//  VKGetConversationsResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGetConversationsResponse : Decodable {
    
    struct Item : Decodable {
        let conversation : VKConversationModel
        let lastMessage : VKMessageModel
    }
    
    let count : Int
    let items : [Item]
    let unreadCount : Int?
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
}
