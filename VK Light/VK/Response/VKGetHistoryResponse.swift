//
//  VKGetHistoryResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGetHistoryResponse : Decodable {
    let count : Int
    let items : [VKMessageModel]
    let conversations : [VKConversationModel]?
    let profiles : [VKProfileModel]?
    let groups : [VKGroupModel]?
    
    func getProfileById(id: Int) -> VKProfileModel? {
        guard let profiles = profiles else {return nil}
        
        for profile in profiles {
            if profile.id == id {
                return profile
            }
        }
        
        return nil
    }
    
    func getGroupById(id: Int) -> VKGroupModel? {
        guard let groups = groups else {return nil}
        
        for group in groups {
            if group.id == id {
                return group
            }
        }
        
        return nil
    }
}
