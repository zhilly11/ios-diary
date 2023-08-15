//  Diary - DiaryTitleView.swift
//  Created by zhilly on 2023/06/13

import UIKit

final class DiaryTitleView: UIView {
    private let weatherIconImage: UIImageView = {
        let imageView: UIImageView = .init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                
        return imageView
    }()
    
    private let createdAtLabel: UILabel = {
        let label: UILabel = .init()
        
        label.textColor = UIColor.getTextColor()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(createdAt: Date, weatherIconID: String?) {
        super.init(frame: .zero)
        
        configure()
        setupTitle(createdAt: createdAt)
        setupWeatherIcon(id: weatherIconID)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        setupView()
    }
    
    private func setupView() {
        [weatherIconImage, createdAtLabel].forEach(contentStackView.addArrangedSubview(_:))
        self.addSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: self.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            weatherIconImage.widthAnchor.constraint(equalToConstant: 30),
            weatherIconImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupTitle(createdAt: Date) {
        createdAtLabel.text = DateFormatter.converted(date: createdAt,
                                                      locale: Locale.preference,
                                                      dateStyle: .long)
    }
    
    private func setupWeatherIcon(id: String?) {
        weatherIconImage.loadWeatherIcon(id: id)
    }
}
