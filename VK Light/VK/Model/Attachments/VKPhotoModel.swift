//
//  VKPhotoModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKPhotoModel : Decodable {
    
    struct Size : Decodable {
        let type: String
        let url: URL
        let width: Int
        let height: Int
    }
    
    let id: Int
    let albumId: Int
    let ownerId: Int
    let userId: Int? //только если размещена в сообществе, = 100 если прислано от имени сообшества
    let text: String // описание фотографии
    let date: Date
    let sizes: [Size]
    
    /* недоступны для фотографий, загруженных на сайт до 2012 года */
    let width: Int?
    let height: Int?
}
