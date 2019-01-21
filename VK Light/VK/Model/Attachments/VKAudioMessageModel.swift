//
//  VKAudioMessageModel.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

struct VKAudioMessageModel : Decodable {
    let id: Int
    let accessKey: String
    let duration: Int
    let ownerId: Int
    let linkMp3: URL
    let linkOgg: URL
    let waveform: [Int] // всегда 128 элементов
}
