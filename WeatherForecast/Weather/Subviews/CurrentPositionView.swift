//
//  CurrentPositionView.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit

final class CurrentPositionView: UIView {

    enum Constants: DSSizes {
        static let numberOfLines = 1
    }

    private lazy var currentPlaceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        label.font = .dsFont(.bodySmall)
        label.textColor = UIColor(token: \.core.secondary.text)
        label.text = "Текущее место"
        return label
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        label.font = .dsFont(.titleCity)
        label.textColor = UIColor(token: \.core.primary.text)
        label.text = "Город"
        return label
    }()
    private lazy var currentTemperatureLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        label.font = .dsFont(.displayTemp)
        label.textColor = UIColor(token: \.core.primary.text)
        label.text = "20"
        return label
    }()
    private lazy var feelslikeLable: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        label.font = .dsFont(.bodySmall)
        label.textColor = UIColor(token: \.core.secondary.text)
        label.text = "Ощущается как -6"
        return label
    }()
    private lazy var maxMinLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = Constants.numberOfLines
        label.textAlignment = .center
        label.font = .dsFont(.bodyPrimary)
        label.textColor = UIColor(token: \.core.primary.text)
        label.text = "Макс.: 3, мин.: -4"
        return label
    }()
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = Constants.space(.xs)
        stack.axis = .vertical
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.add(subview: stack)
        stack.addArranged(subviews: [
            currentPlaceLabel,
            nameLabel,
            currentTemperatureLabel,
            feelslikeLable,
            maxMinLabel
        ])

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: self.topAnchor),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    func configureWith(_ model: CurrentPositionViewModel) {
        nameLabel.text = model.city
        currentTemperatureLabel.text = model.current
        feelslikeLable.text = "Ощущается как \(model.feelsLike)"
        maxMinLabel.text = "Макс.: \(model.maxTemp), мин.: \(model.minTemp)"
    }
}
