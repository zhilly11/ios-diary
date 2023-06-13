//  Diary - UIImageView+Extension.swift
//  Created by zhilly on 2023/06/13

import UIKit

extension UIImageView {
    func loadWeatherIcon(id: String?) {
        let networkManager: NetworkManager = NetworkManager()
        guard let id: String = id else { return }
        
        Task.init {
            let iconImageData: Data = try await networkManager.fetchWeatherIcon(id: id)
            self.image = UIImage(data: iconImageData)
        }
    }
}
