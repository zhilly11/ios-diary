//  Diary - NetworkError.swift
//  Created by zhilly on 2023/06/04

enum NetworkError: Error {
    case responseFail
    case url
    case invalidServerResponse
    case unsupportedImage
    case unsupportedData
}
