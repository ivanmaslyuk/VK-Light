//
//  VKAudioModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKAudio : Decodable {
    
    enum VKMusicGenre : Int, Decodable {
        case rock = 1
        case pop = 2
        case rapAndHipHop = 3
        case easyListening = 4
        case houseAndDance = 5
        case instrumental = 6
        case metal = 7
        case alternative = 21
        case dubstep = 8
        case jazzAndBlues = 1001
        case drumAndBass = 10
        case trance = 11
        case chanson = 12
        case ethnic = 13
        case acousticAndVocal = 14
        case reggae = 15
        case classical = 16
        case indiePop = 17
        case speech = 19
        case electroPopAndDisco = 22
        case other = 18
    }
    
    let id: Int
    let ownerId: Int
    let artist: String
    let title: String
    let duration: Int
    let url: URL
    let lyricsId: Int?
    let albumId: Int?
    let genreId: VKMusicGenre?
    let date: Date
    let isHq: Bool
}
