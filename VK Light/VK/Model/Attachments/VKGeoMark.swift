//
//  VKGeoMarkModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 03/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKGeoMark : Decodable {
    let type: String
    let coordinates: String
    let place: String? // описание
}
