//
//  NotificationDegugger.swift
//  VK Light
//
//  Created by Иван Маслюк on 04/12/2018.
//  Copyright © 2018 Иван Маслюк. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class NotificationDebugger {
    static func print(text: String) {
        let content = UNMutableNotificationContent()
        content.title = "Debug"
        content.body = text
        content.sound = .none
        let identifier = "VKLightLocalNotification"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
}

class NotificationDebuggerDelegate : NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
}
