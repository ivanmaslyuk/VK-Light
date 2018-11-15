//
//  VKResponse.swift
//  VK Light
//
//  Created by Иван Маслюк on 14/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKResponse<T : Decodable> : Decodable {
    
    struct VKError : Decodable {
        let errorCode : Int
        let errorMsg : String
    }
    
    let response: T?
    let error : VKError?
}
