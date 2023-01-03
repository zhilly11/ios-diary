//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: ManagedObjectModel {
    let objectID: String
    var content: String
    let createdAt: Date
    let weatherCondition: String?
    let weatherIconID: String?
    
    init?(from diaryData: DiaryData) {
        self.objectID = diaryData.objectID.uriRepresentation().absoluteString
        self.content = diaryData.content
        self.createdAt = diaryData.createdAt
        self.weatherCondition = diaryData.weatherCondition
        self.weatherIconID = diaryData.weatherIconID
    }
}
