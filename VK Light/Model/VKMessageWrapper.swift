//
//  VKMessageWrapper.swift
//  VK Light
//
//  Created by Иван Маслюк on 25/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKMessageWrapper {
    let message: VKMessageModel
    let profile: VKProfile?
    let group: VKGroup?
    var forwardedMessages: [VKMessageWrapper]
    
    var isSticker: Bool {
        get {
            if message.attachments.count > 0 {
                return message.attachments[0].type == .sticker
            }
            return false
        }
    }
    
    var hasText : Bool {
        return !message.text.isEmpty
    }
    
    var formattedTime : String {
        get {
            let calendar = Calendar.current
            let date = message.date
            
            let minutes = String(calendar.component(.minute, from: date))
            let formattedMinutes = minutes.count == 1 ? "0" + minutes : minutes
            return String(calendar.component(.hour, from: date)) + ":" + formattedMinutes
        }
    }
    
}
