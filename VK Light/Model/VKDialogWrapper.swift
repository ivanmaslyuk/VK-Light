//
//  VKDialogWrapper.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKDialogWrapper {
    private var _unread: Int
    private var _outRead: Int
    
    init(dialog: VKConversationModel, profile: VKProfile?, group: VKGroup?, lastMessage: VKMessageWrapper) {
        self.dialog = dialog
        self.profile = profile
        self.group = group
        self.lastMessage = lastMessage
        self._unread = dialog.unreadCount ?? 0
        self._outRead = dialog.outRead
    }
    
    let dialog : VKConversationModel
    let profile : VKProfile?
    let group : VKGroup?
    var lastMessage: VKMessageWrapper
    
    var isChat : Bool {
        return dialog.peer.type == .chat
    }
    
    var dialogTitle : String? {
        switch dialog.peer.type {
        case .user:
            guard let profile = profile else { return nil }
            return profile.firstName + " " + profile.lastName
        case .chat:
            guard let chat = dialog.chatSettings else { return nil }
            return chat.title
        case .group:
            guard let group = group else { return nil }
            return group.name
        case .email:
            return "ЧАТ С EMAIL"
        }
    }
    
    var photo100 : URL? {
        switch dialog.peer.type {
        case .chat:
            guard let chat = dialog.chatSettings else { return nil }
            return chat.photo?.photo100
        case .email:
            return nil
        case .group:
            guard let group = group else { return nil }
            return group.photo100
        case .user:
            guard let profile = profile else { return nil }
            return profile.photo100
        }
    }
    
    var unreadCount: Int {
        get {
            return _unread
        }
        set {
            _unread = newValue
        }
    }
    
    var outRead: Int {
        get { return _outRead }
        set { _outRead = newValue }
    }
}
