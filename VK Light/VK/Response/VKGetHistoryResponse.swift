//
//  VKGetHistoryResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 18/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGetHistoryResponse : Decodable {
    let count : Int
    let items : [VKMessageModel]
    let conversations : [VKConversationModel]?
    let profiles : [VKProfileModel]?
}
