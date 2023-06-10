//  Diary - DiaryManager.swift
//  Created by Ayaan, zhilly on 2023/01/02.

import Foundation

enum DiaryError: Error {
    case failedFetchEntity
    case invalidObjectID
}

extension DiaryError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .failedFetchEntity:
            return "다이어리 가져오기 실패"
        case .invalidObjectID:
            return "잘못된 다이어리 ID"
        }
    }
}
