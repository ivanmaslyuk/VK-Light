//
//  VKAttachmentModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 19/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKAttachmentModel : Decodable {
    enum AttachmentType : String, Decodable {
        case sticker
        case photo
        case video
        case doc
        case audio
        case link
        case market
        case marketAlbum
        case wall
        case wallReply
        case gift
        case audioMessage = "audio_message"
        case graffiti
        case poll
    }
    
    let type : AttachmentType
    
    let photo: VKPhotoModel?
    let video: VKVideoModel?
    let audio: VKAudioModel?
    let doc: VKDocumentModel?
    let link: VKLinkModel?
    // let market
    // let marketAlbum
    let wall: VKWallPostModel?
    let wallReply: VKCommentModel?
    let sticker : VKStickerModel?
    let gift: VKGiftModel?
    let audioMessage: VKAudioMessageModel?
}
