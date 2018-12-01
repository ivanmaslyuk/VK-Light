//
//  VKLPHistoryItemModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 20/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKLPHistoryItemModel : Decodable {
    enum Kind : Int, Decodable {
        case tempNotImplemented = -1
        case messageFlagsChanged = 1
        case messageFlagsSet = 2
        case messageFlagsReset = 3
        case newMessage = 4
        case messageEdited = 5
        case incomingMessagesRead = 6
        case sentMessagesRead = 7
        case friendWentOnline = 8
        case friendWentOffline = 9
        case dialogFlagsReset = 10
        case dialogFlagsChanged = 11
        case dialogFlagsSet = 12
        case messagesDeletedInDialog = 13
        case messagesRestored = 14
        case chatPropertiesModified = 51
        case chatInfoChanged = 52
        case userIsTyping = 61
        case userIsTypingInChat = 62
        case userMadeCall = 70
        case counterInLeftMenuChanged = 80
        case notificationPreferencesChanged = 114
    }
    
    let kind: Kind
    
    /*  4, 5  */
    let messageFlags: VKLPMessageFlags?
    let messageId: Int?
    let peerId: Int?
    let date: Date?
    
    /*  8, 9   */
    let extra: Int?
    let lastOnline: Date?
    
    /* 6, 7 */
    let localId: Int?
    
    /* 80 */
    let count: Int?
    
    /* 61, 62 */
    let userId: Int? //8,9
    let chatId: Int?
    
    /* 10, 11, 12 */
    let dialogFlags: VKLPDialogFlags?
    
    /* 51 */
    let causedBySelf: Bool?
    
    /* 52 */
    let dialogEventType: VKLPChatEventType?
    let dialogEventPayload: Int?
    
    /* 70 */
    let callId: Int?
    
    /* 114 */
    let soundEnabled: Bool?
    let disabledUntil: Int? // -1 если звук оповещений выключен навсегда
    
    
    init(kind: Kind, messageId: Int? = nil, messageFlags: VKLPMessageFlags? = nil, peerId: Int? = nil, extra: Int? = nil, lastOnline: Date? = nil, localId: Int? = nil, count: Int? = nil, userId: Int? = nil, chatId: Int? = nil, date: Date? = nil, dialogFlags: VKLPDialogFlags? = nil, causedBySelf: Bool? = nil, dialogEventType: VKLPChatEventType? = nil, callId: Int? = nil, dialogEventPayload: Int? = nil, soundEnabled: Bool? = nil, disabledUntil: Int? = nil) {
        self.kind = kind
        self.messageFlags = messageFlags
        self.peerId = peerId
        self.messageId = messageId
        self.extra = extra
        self.lastOnline = lastOnline
        self.localId = localId
        self.count = count
        self.userId = userId
        self.chatId = chatId
        self.date = date
        self.dialogFlags = dialogFlags
        self.causedBySelf = causedBySelf
        self.dialogEventType = dialogEventType
        self.dialogEventPayload = dialogEventPayload
        self.callId = callId
        self.soundEnabled = soundEnabled
        self.disabledUntil = disabledUntil
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let kind: Kind = try container.decode(Kind.self)
        switch kind {
            
        case .messageFlagsChanged:
            let messageId = try container.decode(Int.self)
            let messageFlags = try container.decode(VKLPMessageFlags.self)
            self.init(kind: kind, messageId: messageId, messageFlags: messageFlags)
            
        case .messageFlagsSet:
            let messageId = try container.decode(Int.self)
            let messageFlags = try container.decode(VKLPMessageFlags.self)
            self.init(kind: kind, messageId: messageId, messageFlags: messageFlags)
            
        case .messageFlagsReset:
            let messageId = try container.decode(Int.self)
            let messageFlags = try container.decode(VKLPMessageFlags.self)
            self.init(kind: kind, messageId: messageId, messageFlags: messageFlags)
            
        case .newMessage:
            let messageId = try container.decode(Int.self)
            let messageFlags = try container.decode(VKLPMessageFlags.self)
            let peerId = try container.decode(Int.self)
            self.init(kind: kind, messageId: messageId, messageFlags: messageFlags, peerId: peerId)
            
        case .messageEdited:
            let messageId = try container.decode(Int.self)
            let messageFlags = try container.decode(VKLPMessageFlags.self)
            let peerId = try container.decode(Int.self)
            let date = try container.decode(Date.self)
            self.init(kind: kind, messageId: messageId, messageFlags: messageFlags, peerId: peerId, date: date)
            
        case .friendWentOnline:
            let userId = try container.decode(Int.self)
            let extra = try container.decode(Int.self)
            let lastOnline = try container.decode(Date.self)
            self.init(kind: kind, extra: extra, lastOnline: lastOnline, userId: -userId)
            
        case .friendWentOffline:
            let userId = try container.decode(Int.self)
            let extra = try container.decode(Int.self)
            let lastOnline = try container.decode(Date.self)
            self.init(kind: kind, extra: extra, lastOnline: lastOnline, userId: -userId)
            
        case .incomingMessagesRead:
            let peerId = try container.decode(Int.self)
            let localId = try container.decode(Int.self)
            self.init(kind: kind, peerId: peerId, localId: localId)
            
        case .sentMessagesRead:
            let peerId = try container.decode(Int.self)
            let localId = try container.decode(Int.self)
            self.init(kind: kind, peerId: peerId, localId: localId)
            
        case .dialogFlagsReset: //10
            let peerId = try container.decode(Int.self)
            let dialogFlags = try container.decode(VKLPDialogFlags.self)
            self.init(kind: kind, peerId: peerId, dialogFlags: dialogFlags)
            
        case .dialogFlagsChanged: //11
            let peerId = try container.decode(Int.self)
            let dialogFlags = try container.decode(VKLPDialogFlags.self)
            self.init(kind: kind, peerId: peerId, dialogFlags: dialogFlags)
            
        case .dialogFlagsSet: //12
            let peerId = try container.decode(Int.self)
            let dialogFlags = try container.decode(VKLPDialogFlags.self)
            self.init(kind: kind, peerId: peerId, dialogFlags: dialogFlags)
            
        case .messagesDeletedInDialog: //13
            let peerId = try container.decode(Int.self)
            let localId = try container.decode(Int.self)
            self.init(kind: kind, peerId: peerId, localId: localId)
            
        case .messagesRestored: //14
            let peerId = try container.decode(Int.self)
            let localId = try container.decode(Int.self)
            self.init(kind: kind, peerId: peerId, localId: localId)
            
        case .chatPropertiesModified: //51
            let chatId = try container.decode(Int.self)
            let causedBySelf = try container.decode(Int.self)
            self.init(kind: kind, chatId: chatId, causedBySelf: causedBySelf == 1)
            
        case .chatInfoChanged: //52
            let type = try container.decode(VKLPChatEventType.self)
            let payload = try container.decode(Int.self)
            self.init(kind: kind, dialogEventType: type, dialogEventPayload: payload)
            
        case .userIsTyping: //61
            let userId = try container.decode(Int.self)
            self.init(kind: kind, userId: userId)
            
        case .userIsTypingInChat: //62
            let userId = try container.decode(Int.self)
            let chatId = try container.decode(Int.self)
            self.init(kind: kind, userId: userId, chatId: chatId)
            
        case .userMadeCall: //70
            let userId = try container.decode(Int.self)
            let callId = try container.decode(Int.self)
            self.init(kind: kind, userId: userId, callId: callId)
            
        case .counterInLeftMenuChanged: // 80
            let count = try container.decode(Int.self)
            self.init(kind: kind, count: count)
            
        case .notificationPreferencesChanged: //114
            let peerId = try container.decode(Int.self)
            let sound = try container.decode(Int.self)
            let until = try container.decode(Int.self)
            self.init(kind: kind, peerId: peerId, soundEnabled: sound == 1, disabledUntil: until)
            
        default:
            print("Еще не реализованное событие: \(kind)")
            self.init(kind: .tempNotImplemented)
        }
    }
    
}





struct VKLPMessageFlags : Decodable {
    let isUnread: Bool
    let isOutbox: Bool
    let isReplied: Bool
    let isImportant: Bool
    let isChat: Bool
    let isFromFriend: Bool
    let isSpam: Bool
    let isDeleted: Bool
    let isFixed: Bool
    let hasMedia: Bool
    let isHidden: Bool
    let isDeletedForEveryone: Bool
    
    init(isUnread: Bool, isOutbox: Bool, isReplied: Bool, isImportant: Bool, isChat: Bool, isFromFriend: Bool, isSpam: Bool, isDeleted: Bool, isFixed: Bool, hasMedia: Bool, isHidden: Bool, isDeletedForEveryone: Bool) {
        self.isUnread = isUnread
        self.isOutbox = isOutbox
        self.isReplied = isReplied
        self.isImportant = isImportant
        self.isChat = isChat
        self.isFromFriend = isFromFriend
        self.isSpam = isSpam
        self.isDeleted = isDeleted
        self.isFixed = isFixed
        self.hasMedia = hasMedia
        self.isHidden = isHidden
        self.isDeletedForEveryone = isDeletedForEveryone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        
        self.init(isUnread: (rawValue & 1) == 1,
                  isOutbox: (rawValue & 2) == 2,
                  isReplied: (rawValue & 4) == 4,
                  isImportant: (rawValue & 8) == 8,
                  isChat: (rawValue & 16) == 16,
                  isFromFriend: (rawValue & 32) == 32,
                  isSpam: (rawValue & 64) == 64,
                  isDeleted: (rawValue & 128) == 128,
                  isFixed: (rawValue & 256) == 256,
                  hasMedia: (rawValue & 512) == 512,
                  isHidden: (rawValue & 65536) == 65536,
                  isDeletedForEveryone: (rawValue & 131072) == 131072)
    }
}



struct VKLPDialogFlags : Decodable {
    let isImportant: Bool
    let isUnread: Bool
    
    init(isImportant: Bool, isUnread: Bool) {
        self.isUnread = isUnread
        self.isImportant = isImportant
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(Int.self)
        
        self.init(isImportant: (rawValue & 1) == 1,
                  isUnread: (rawValue & 2) == 2)
    }
}



enum VKLPChatEventType : Int, Decodable {
    case nameChanged = 1
    case coverChanged = 2
    case newAdmin = 3
    case messagePinned = 5
    case userJoined = 6
    case userLeft = 7
    case userWasKicked = 8
    case userStrippedOfAdminRights = 9
}
