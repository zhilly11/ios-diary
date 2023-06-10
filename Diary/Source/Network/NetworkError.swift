//  Diary - NetworkError.swift
//  Created by zhilly on 2023/06/04

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case unsupportedData
}

extension NetworkError: LocalizedError {
  public var errorDescription: String? {
      switch self {
      case .invalidURL:
          return "url에 문제가 생겼습니다."
      case .invalidServerResponse:
          return "서버로부터 응답이 없습니다."
      case .unsupportedData:
          return "데이터가 잘못되었습니다."
      }
  }
}
