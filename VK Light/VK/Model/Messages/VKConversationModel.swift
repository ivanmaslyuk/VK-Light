//
//  VKConversationModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKConversationModel : Decodable {
    
    struct Peer : Decodable {
        
        enum PeerType : String, Decodable {
            case user
            case chat
            case group
            case email
        }
        
        let id : Int
        let type : PeerType
        let localId : Int
        
    }
    
    struct PushSettings : Decodable {
        let disabledUntil : Int
        let disabledForever : Bool
        let noSound : Bool
    }
    
    struct WritingPermission : Decodable {
        let allowed : Bool
        let reason : Int?
    }
    
    struct PinnedMessage : Decodable {
        let id : Int
        let date : Date
        let fromId : Int
        let text : String
    }
    
    struct ChatSettings : Decodable {
        
        enum UserState : String, Decodable {
            case member = "in"
            case kicked
            case left
        }
        
        struct ChatPhoto : Decodable {
            let photo50 : URL
            let photo100 : URL
            let photo200 : URL
        }
        
        let membersCount : Int?
        let title : String
        let pinnedMessage : PinnedMessage?
        let state : UserState
        let photo : ChatPhoto?
        let activeIds : [Int]
        let isGroupChannel : Bool
        
    }
    
    
    let peer : Peer
    let inRead : Int
    let outRead : Int
    let unreadCount : Int?
    let important : Bool? //только для сообщений сообществ
    let unanswered : Bool?
    let pushSettings : PushSettings?
    let canWrite : WritingPermission
    let chatSettings : ChatSettings?
    
    
}
