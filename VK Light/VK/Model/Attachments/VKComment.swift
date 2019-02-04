//
//  VKCommentModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 03/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKComment : Decodable {
    
    struct CommentThread : Decodable {
        let count: Int
        let items: [VKComment]?
        let canPost: Bool
        let showReplyButton: Bool // нужно ли отображать кнопку «ответить» в ветке
        let groupsCanPost: Bool
    }
    
    let id: Int
    let fromId: Int
    let date: Date
    let text: String
    let replyToUser: Int?
    let replyToComment: Int?
    let attachments: [VKAttachment]?
    let parentsStack: [Int]?
    let thread: CommentThread
}
