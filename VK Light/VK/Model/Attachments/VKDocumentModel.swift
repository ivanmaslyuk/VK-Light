//
//  VKDocumentModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKDocumentModel : Decodable {
    
    enum DocType : Int, Decodable {
        case textFile = 1
        case archive = 2
        case gif = 3
        case image = 4
        case audio = 5
        case video = 6
        case ebook = 7
        case unknown = 8
    }
    
    struct Preview : Decodable {
        struct Thumbnail : Decodable {
            struct Size : Decodable {
                let type: String
                let src: URL
                let width: Int
                let height: Int
            }
            let sizes: [Size]
        }
        struct Graffiti : Decodable {
            let src: URL
            let width: Int
            let height: Int
        }
        
        let photo: Thumbnail?
        let graffiti: Graffiti?
    }
    
    let id: Int
    let ownerId: Int
    let title: String
    let size: Int // в байтах
    let ext: String // расширение
    let url: URL
    let date: Date
    let type: DocType
    let preview: Preview?
}
