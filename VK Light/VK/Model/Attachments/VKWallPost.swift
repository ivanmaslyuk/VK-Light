//
//  VKWallPostModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 03/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKWallPost : Decodable {
    
    struct Likes : Decodable {
        let count: Int
        let userLikes: VKBool
        let canLike: VKBool
        let canPublish: VKBool // можно ли сделать репост
    }
    
    struct Reposts : Decodable {
        let count: Int
        let userReposted: VKBool
    }
    
    struct Views : Decodable {
        let count: Int
    }
    
    enum PostType : String, Decodable {
        case post
        case copy
        case reply
        case postpone
        case suggest
    }
    
    let id: Int
    let ownerId: Int? // владелец стены
    let toId: Int? // владелец стены возвращается здесь если атачмент пришел в сообщении
    let fromId: Int
    let createdBy: Int? // идентификатор администратора, который опубликовал запись (возвращается только для сообществ при запросе с ключом доступа администратора).
    let date: Date
    let text: String
    let replyOwnerId: Int? // идентификатор владельца записи, в ответ на которую была оставлена текущая
    let replyPostId: Int?
    let friendsOnly: VKBool? // 1 если только для друзей
    //let comments
    let likes: Likes?
    let reposts: Reposts?
    let views: Views?
    let postType: PostType
    //let postSource
    let attachments: [VKAttachment]?
    let geo: VKGeoMark?
    let signerId: Int?
    let copyHistory: [VKWallPost]?
    let canPin: VKBool?
    let canDelete: VKBool?
    let canEdit: VKBool?
    let isPinned: VKBool?
    let markedAsAds: VKBool?
    let isFavorite: Bool?
}
