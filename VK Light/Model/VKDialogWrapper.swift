//
//  VKDialogWrapper.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKDialogWrapper {
    let dialog : VKConversationModel
    let profile : VKProfile?
    let group : VKGroup?
    let lastMessage: VKMessageWrapper
    
    var isChat : Bool {
        return dialog.chatSettings != nil
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
    
    
}
