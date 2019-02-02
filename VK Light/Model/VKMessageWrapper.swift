//
//  VKMessageWrapper.swift
//  VK Light
//
//  Created by Иван Маслюк on 25/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKMessageWrapper {
    let message: VKMessage
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
        return message.text.trimmingCharacters(in: .whitespaces) != ""
    }
    
    var isSingleImage : Bool {
        guard !message.attachments.isEmpty else { return false }
        return !hasText && message.attachments.count == 1 && message.attachments[0].type == .photo && forwardedMessages.isEmpty
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
    
    func formattedTime(hoursOnly: Bool) -> String {
        let calendar = Calendar.current
        let date = message.date
        
        let minutes = String(calendar.component(.minute, from: date))
        
        
        let formattedMinutes = minutes.count == 1 ? "0" + minutes : minutes
        let result = String(calendar.component(.hour, from: date)) + ":" + formattedMinutes
        
        if !hoursOnly {
//            let yearNow = calendar.component(.year, from: now)
//            let monthNow = calendar.component(.month, from: now)
//            let dayNow = calendar.component(.day, from: now)
//
//            let year = calendar.component(.year, from: date)
//            let month = calendar.component(.month, from: date)
//            let day = calendar.component(.day, from: date)
            
            // is yesterday
            let components = calendar.dateComponents([.day, .month, .year], from: date, to: Date())
            if date.isYesterday { return "вчера" }
            if components.day! >= 2 && components.day! <= 7 {
                return "\(components.day!) назад"
            }
        }
        
        return result
    }
    
    private func monthName(of month: Int) -> String {
        switch month {
        case 1:
            return "янв."
        case 2:
            return "фев."
        case 3:
            return "март."
        case 4:
            return "апр."
        case 5:
            return "май."
        case 6:
            return "инюн."
        case 7:
            return "июл."
        case 8:
            return "авг."
        case 9:
            return "сент."
        case 10:
            return "окт."
        case 11:
            return "нояб."
        case 12:
            return "дек."
        default:
            return ""
        }
    }
    
    
    
}

extension Date {
    var day : Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var month : Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var year : Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var isYesterday : Bool {
        let diff = Calendar.current.dateComponents([.hour], from: self, to: Date())
        return diff.hour! > 24 && diff.hour! < 48
    }
}
