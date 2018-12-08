//
//  VKLinkModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 03/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKLinkModel : Decodable {
    
    struct Product : Decodable {
        struct Price : Decodable {
            struct Currency : Decodable {
                let id: Int
                let name: String
            }
            
            let amount: Int
            let currency: Currency
            let text: String // строка с локализованной ценой и валютой
        }
        
        let price: Price
    }
    
    struct Button : Decodable {
        let title: String // название кнопки
    }
    
    let url: URL
    let title: String // заголовок
    let caption: String? // подпись
    let description: String // описание
    let photo: VKPhotoModel?
    let product: Product?
    let button: Button?
    let previewPage: String?
    let previewUrl: URL?
}
