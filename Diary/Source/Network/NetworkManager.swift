//  Diary - NetworkManager.swift
//  Created by zhilly on 2023/06/03

import Foundation
import UIKit

final class NetworkManager {
    private enum API {
        static let key: String = "964504ece769bee1b050028446a27f65"
        static let appid: String = "&appid="
        static let iconURL: String = "https://openweathermap.org/img/wn/"
        static let imageFormat: String = "@2x.png"
        
        static func getURL(latitude: String, longitude: String) -> String {
            return "https://api.openweathermap.org/data/2.5/weather?lat="
            + latitude
            + "&lon="
            + longitude
            + appid
            + key
        }
    }
    
    func getWeatherInformation(latitude: String, longitude: String) async throws -> Weather {
        guard let url: URL = .init(string: API.getURL(latitude: latitude, longitude: longitude)) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response): (Data, URLResponse) = try await URLSession.shared.data(from: url)
        let successRange: (Range<Int>) = (200..<300)
        
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        
        guard let weatherInformation: WeatherInformation = try? decoder.decode(
            WeatherInformation.self, from: data
        ),
              let firstItem: Weather = weatherInformation.weather.first else {
            throw NetworkError.unsupportedData
        }
        
        return firstItem
    }
    
    func fetchWeatherIcon(id: String) async throws -> Data {
        guard let url: URL = .init(string: API.iconURL + id + API.imageFormat) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response): (Data, URLResponse) = try await URLSession.shared.data(from: url)
        let successRange: (Range<Int>) = (200..<300)
        
        guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        return data
    }
}
