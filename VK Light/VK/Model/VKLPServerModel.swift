//
//  VKGetLPServerResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 20/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKLPServerModel : Decodable {
    let key: String
    let server: URL
    let ts: Int
    let pts: Int
}
