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
        case messageFlagsAdded = 2
        case messageFlagsReset = 3
        case newMessage = 4
        case messageEdited = 5
        case allIncomingMessagesRead = 6
        case allSentMessagesRead = 7
        case friendWentOnline = 8
        case friendWentOffline = 9
        case dialogFlagsReset = 10
        case dialogFlagsChanged = 11
        case dialogFlagsAdded = 12
        case allMessagesInDialogDeleted = 13
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
    let messageFlags: VKLPMessageFlags? //TODO: сделать декодер
    let messageId: Int?
    let peerId: Int?
    let messageDate: Date?
    let messageText: String?
    
    init(kind: Kind, messageId: Int? = nil, messageFlags: VKLPMessageFlags? = nil, peerId: Int? = nil, messageDate: Date? = nil, messageText: String? = nil) {
        self.kind = kind
        self.messageFlags = messageFlags
        self.peerId = peerId
        self.messageDate = messageDate
        self.messageText = messageText
        self.messageId = nil
    }
    
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        
        let kind: Kind = try container.decode(Kind.self)
        switch kind {
        case .newMessage:
            let messageId = try container.decode(Int.self)
            let messageFlags = try container.decode(VKLPMessageFlags.self)
            let peerId = try container.decode(Int.self)
            let messageDate = try container.decode(Date.self)
            let messageText = try container.decode(String.self)
            self.init(kind: kind, messageId: messageId, messageFlags: messageFlags, peerId: peerId, messageDate: messageDate, messageText: messageText)
        default:
            self.init(kind: .tempNotImplemented)
        }
    }
    
}




struct VKLPNewMessageResponse : Decodable {
    let flags: Int
    let peerId: Int
    let me: Int
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
