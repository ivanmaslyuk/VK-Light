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
    let peerId : Int?
    let fromId : Int
    let text : String
    let randomId : Int?
    let ref : String?
    let refSource : String?
    //let attachments : [Attachment]
    let important : Bool?
    //let geo
    let payload : String? // только для ботов
    let fwdMessages : [VKMessageModel]?
    //let action : Action
    
}
