//
//  VKLPResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 20/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKLPResponse : Decodable {
    let ts: Int?
    let updates : [VKLPHistoryItemModel]?
    let failed : Int?
    //let newPts : Int
}
