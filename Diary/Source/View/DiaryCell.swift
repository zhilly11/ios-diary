//  Diary - DiaryCell.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

final class DiaryCell: UITableViewCell, ReusableView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    private let dateAndBodyStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupViews() {
        [createdDateLabel,
         weatherIconImageView,
         bodyLabel].forEach(dateAndBodyStackView.addArrangedSubview(_:))
        
        [titleLabel,
         dateAndBodyStackView].forEach(contentsStackView.addArrangedSubview(_:))
        
        [contentsStackView].forEach(contentView.addSubview(_:))
        
        let contentsStackViewBottomConstraint = contentsStackView.bottomAnchor.constraint(
            equalTo: contentView.bottomAnchor,
            constant: -8
        )
        contentsStackViewBottomConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            contentsStackViewBottomConstraint,
            contentsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            contentsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 24),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        createdDateLabel.setContentHuggingPriority(.required, for: .horizontal)
        createdDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configure(with diary: Diary) {
        let cellContents = DiaryExtractor.extract(of: diary)
        titleLabel.text = cellContents.title
        bodyLabel.text = cellContents.body
        createdDateLabel.text = cellContents.createdAt
        loadWeatherIcon(id: diary.weatherIconID)
    }
    
    private func loadWeatherIcon(id: String?) {
        let networkManager = NetworkManager()
        guard let id = id else { return }
        
        Task.init {
            let iconImageData = try await networkManager.fetchWeatherIcon(id: id)
            self.weatherIconImageView.image = UIImage(data: iconImageData)
        }
    }
}
