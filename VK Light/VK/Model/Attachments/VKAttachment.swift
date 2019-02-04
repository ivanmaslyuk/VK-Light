//
//  VKAttachmentModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 19/11/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKAttachment : Decodable {
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
    
    let photo: VKPhoto?
    let video: VKVideo?
    let audio: VKAudio?
    let doc: VKDocument?
    let link: VKLink?
    // let market
    // let marketAlbum
    let wall: VKWallPost?
    let wallReply: VKComment?
    let sticker : VKSticker?
    let gift: VKGift?
    let audioMessage: VKAudioMessage?
}
