//
//  NotificationSettingsSubscriber.swift
//  VK Light
//
//  Created by Иван Маслюк on 02/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation

protocol NotificationSettingsSubscriber : class {
    func notificationSettingsChanged(peerId: Int, soundEnabled: Bool, disabledUntil: Int, disabledForever: Bool)
    func watchesNotificationSettingsForPeer() -> Int
    func watchesNotificationSettingsForAllPeers() -> Bool
}
