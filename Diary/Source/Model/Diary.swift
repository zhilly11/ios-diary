//  Diary - Diary.swift
//  Created by Ayaan, zhilly on 2022/12/20

import Foundation

struct Diary: ManagedObjectModel {
    var content: String
    var createdAt: Date
    var objectID: String?
    var weatherMain: String?
    var weatherIconID: String?
    
    init?(from diaryData: DiaryData) {
        guard let content: String = diaryData.content,
              let createdAt: Date = diaryData.createdAt else {
            return nil
        }
        
        self.content = content
        self.createdAt = createdAt
        self.objectID = diaryData.objectID.uriRepresentation().absoluteString
        self.weatherMain = diaryData.weatherMain
        self.weatherIconID = diaryData.weatherIconID
    }
}
