//
//  VKVideoModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKVideo : Decodable {
    let id: Int
    let ownerId: Int
    let title: String
    let description: String
    let duration: Int // длительность в секундах
    
    let photo130: URL
    let photo320: URL
    let photo640: URL?
    let photo800: URL?
    let photo1280: URL?
    
    //let firstFrame130: URL // не стал реализовывать первый кадр
    
    let date: Date
    let addingDate: Date?
    let views: Int
    let comments: Int // количество комментариев
    let player: URL? // HTML5-плеер
    let platform: String?
    let canAdd: VKBool
    let accessKey: String
    let processing: VKBool? // поле возвращается если видео еще обрабатывается и всегда = 1
    let live: VKBool? // возвращается если видео это стрим и всегда = 1 (duration = 0)
    let upcoming: VKBool? // свидетельствует о том что трансляция скоро начнется
    let isFavorite: Bool
}
