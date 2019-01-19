//
//  VKGroupModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGroup : Decodable {
    let id : Int
    let name : String
    let photo50 : URL
    let photo100 : URL
    let photo200 : URL
    let isClosed : Int
}
