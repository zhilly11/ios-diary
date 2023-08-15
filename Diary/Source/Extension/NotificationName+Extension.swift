//  Diary - NotificationName+Extension.swift
//  Created by Ayaan, zhilly on 2022/12/28

import Foundation

extension Notification.Name {
    static let didEnterBackground: Notification.Name = .init("didEnterBackground")
    static let didChangeDiaryCoreData: Notification.Name = .init("didChangeDiaryCoreData")
}
