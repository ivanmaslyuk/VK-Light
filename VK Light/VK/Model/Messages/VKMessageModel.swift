//
//  VKMessageModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKMessageModel : Decodable {
    let id : Int?
    let date : Date
    let peerId : Int? // не передается если сообщение пришло в качестве последнего в диалоге
    let fromId : Int
    let text : String
    let randomId : Int?
    //let ref : String? //не нужно
    //let refSource : String?
    let attachments : [VKAttachmentModel]
    let important : Bool?
    let out: Int? // не передается если сообщение пришло в качестве прикрепленного
    //let payload : String? // только для ботов
    let fwdMessages : [VKMessageModel]?
    //let replyMessage: VKMessageModel?
    
    /* служебные */
    var isOut: Bool {
        get { return out == 1 }
    }
    
}