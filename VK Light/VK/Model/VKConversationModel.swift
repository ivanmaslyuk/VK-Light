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
        
        /*enum CodingKeys : String, CodingKey {
            case id
            case type
            case localId = "local_id"
        }*/
        
    }
    
    struct PushSettings : Decodable {
        
        let disabledUntil : Int
        let disabledForever : Bool
        let noSound : Bool
        
        /*enum CodingKeys : String, CodingKey {
            case disabledUntil = "disabled_until"
            case disabledForever = "disabled_forever"
            case noSound = "no_sound"
        }*/
        
    }
    
    struct WritingPermission : Decodable {
        
        let allowed : Bool
        let reason : Int?
        
        /*enum CodingKeys : String, CodingKey {
            case canWrite = "can_write"
            case reason
        }*/
        
    }
    
    struct PinnedMessage : Decodable {
        
        let id : Int
        let date : Date
        let fromId : Int
        let text : String
        
        /*enum CodingKeys : String, CodingKey {
            case id
            case date
            case fromId = "from_id"
            case text
        }*/
        
    }
    
    struct ChatSettings : Decodable {
        
        enum UserState : String, Decodable {
            case member
            case kicked
            case left
            
            enum CodingKeys : String, CodingKey {
                case member = "in"
                case kicked
                case left
            }
        }
        
        struct ChatPhoto : Decodable {
            let photo50 : URL
            let photo100 : URL
            let photo200 : URL
            
            /*enum CodingKeys : String, CodingKey {
                case photo50 = "photo_50"
                case photo100 = "photo_100"
                case photo200 = "photo_200"
            }*/
        }
        
        let membersCount : Int
        let title : String
        let pinnedMessage : PinnedMessage?
        //let state : UserState
        let photo : ChatPhoto?
        let activeIds : [Int]
        let isGroupChannel : Bool
        
        /*enum CodingKeys : String, CodingKey {
            case membersCount = "members_count"
            case title
            case pinnedMessage = "pinned_message"
            case userState = "state"
            case photo
            case activeIds = "active_ids"
            case isGroupChannel = "is_group_channel"
        }*/
    }
    
    
    let peer : Peer
    let inRead : Int
    let outRead : Int
    let unreadCount : Int?
    //let important : Bool только для сообщений сообществ
    let unanswered : Bool?
    let pushSettings : PushSettings?
    let canWrite : WritingPermission
    let chatSettings : ChatSettings?
    
    /*enum CodingKeys : String, CodingKey {
        case peer
        case lastReadIn = "read_in"
        case lastReadOut = "read_out"
        case unreadCount = "unread_count"
        case important
        case unanswered
        case pushSettings = "push_settings"
        case writingPermission = "can_write"
        case chatSettings = "chat_settings"
    }*/
    
}
