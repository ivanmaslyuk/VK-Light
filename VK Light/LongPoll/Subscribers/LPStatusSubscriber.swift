//
//  LPStatusSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 24/01/2019.
//  Copyright © 2019 Иван Маслюк. All rights reserved.
//

import Foundation

enum LPStatus {
    case ok
    case error
}

protocol LPStatusSubscriber : class {
    func lpStatusChanged(_ status: LPStatus)
}
