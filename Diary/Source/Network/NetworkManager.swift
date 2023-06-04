//  Diary - NetworkManager.swift
//  Created by zhilly on 2023/06/03

import Foundation
import UIKit

final class NetworkManager {
    private enum API {
        static let key: String = "964504ece769bee1b050028446a27f65"
        static let baseURL: String = "https://api.openweathermap.org/data/2.5/weather?q="
        static let appid: String = "&appid="
        static let iconURL: String = "https://openweathermap.org/img/wn/"
        static let imageFormat: String = "@2x.png"
    }
    
    func getWeatherIconID(cityName: String) async throws -> String {
        guard let url = URL(string: API.baseURL + cityName + API.appid + API.key) else {
            throw NetworkError.url
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let successRange = (200..<300)
        
        guard let httpResponse = response as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        let decoder: JSONDecoder = JSONDecoder()
        
        guard let weatherInformation = try? decoder.decode(WeatherInformation.self, from: data),
              let firstItem = weatherInformation.weather.first else {
            throw NetworkError.unsupportedData
        }
        
        return firstItem.icon
    }
    
    func fetchWeatherIcon(name: String) async throws -> UIImage {
        guard let url = URL(string: API.iconURL + name + API.imageFormat) else {
            throw NetworkError.url
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        let successRange = (200..<300)
        
        guard let httpResponse = response as? HTTPURLResponse,
              successRange.contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.unsupportedImage
        }
        
        return image
    }
}
