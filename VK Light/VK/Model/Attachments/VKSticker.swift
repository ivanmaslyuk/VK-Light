//
//  VKStickerModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 19/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKSticker : Decodable {
    
    struct VKStickerImage : Decodable {
        let url : URL
        let width : Int
        let height : Int
    }
    
    let productId : Int // id набора
    let stickerId : Int // id стикера
    let images : [VKStickerImage] // изображения с прозрачным фоном
}
