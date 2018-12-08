//
//  VKGiftModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 03/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGiftModel : Decodable {
    let id: Int
    let thumb256: URL
    let thumb96: URL
    let thumb48: URL
}
