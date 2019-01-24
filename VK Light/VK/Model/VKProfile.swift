//
//  VKProfileModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 15/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKProfile : Decodable {
    let id : Int
    let firstName : String
    let lastName : String
    let deactivated : String? // deleted или banned
    let photo100: URL?
    let online: VKBool
    let onlineMobile: VKBool?
    
    var formattedName : String {
        get { return firstName + " " + lastName }
    }
}
