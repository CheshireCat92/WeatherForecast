//
//  HourlyForecastCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit
import Kingfisher

final class HourlyForecastCollectionViewCell: UICollectionViewCell {

    private enum Constants: DSSizes { }

    private lazy var timeLable: UILabel = {
        let label = UILabel()
        label.text = "Сейчас"
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "21"
        return label
    }()

    private lazy var forecastImage: UIImageView = {
        UIImageView(image: UIImage(systemName: "cloud.sun"))
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        forecastImage.image = nil
    }

    override func prepareForReuse() {
        forecastImage.image = nil
        temperatureLabel.text = nil
        timeLable.text = nil
    }

    private func setupUI() {
        backgroundColor = .init(token: \.core.primary.surface)
        layer.cornerRadius = Constants.radius(.lg)
        layer.cornerCurve = .circular

        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.axis = .vertical
        stack.spacing = Constants.space(.sm)

        add(subview: stack)

        stack.addArranged(subviews: [
            timeLable,
            forecastImage,
            temperatureLabel
        ])

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.space(.sm)),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.space(.sm)),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

    }

    func configure() {

    }

}
