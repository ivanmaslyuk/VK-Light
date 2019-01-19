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
}
