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
    // let groups : [VKGroupModel]
    
    func findProfileById(id : Int) -> VKProfileModel? {
        if profiles != nil {
            for profile in profiles! {
                if profile.id == id {
                    return profile
                }
            }
        }
        return nil
    }
}
