//
//  DailyForecastDayView.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit
import Kingfisher

final class DailyForecastDayView: UIView {

    private enum Constants: DSSizes {
        static let dividerHeight: CGFloat = 1
        static let forecastImageWidth: CGFloat = 50
        static let dayLabelWidth: CGFloat = 70
    }

    private lazy var dayLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .dsFont(.bodyPrimary)
        return label
    }()

    private lazy var forecastImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var minTemperatureLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .dsFont(.bodyPrimary)
        label.textColor = .init(token: \.semantic.temp.min)
        return label
    }()

    private lazy var maxTemperatureLabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .dsFont(.bodyPrimary)
        label.textColor = .init(token: \.semantic.temp.max)
        return label
    }()

    private lazy var divider = {
        let view = UIView()
        view.backgroundColor = .init(token: \.core.divider)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    convenience init(model: DayViewModel) {
        self.init()
        forecastImage.kf.setImage(with: model.imageURL)
        maxTemperatureLabel.text = model.maxTemp
        minTemperatureLabel.text = model.minTemp
        dayLabel.text = model.day

        if model.isCurrentDay {
            backgroundColor = .init(token: \.core.primary.accent)
            dayLabel.textColor = .init(token: \.semantic.state.activeText)
            maxTemperatureLabel.textColor = .init(token: \.semantic.state.activeText)
            minTemperatureLabel.textColor = .init(token: \.semantic.state.activeText)
        }

        layoutSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .init(token: \.core.primary.surface)
        
        add(subviews: [
            dayLabel,
            forecastImage,
            minTemperatureLabel,
            maxTemperatureLabel,
            divider
        ])

        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: Constants.dividerHeight),

            dayLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.space(.md)),
            dayLabel.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -Constants.space(.md)),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.space(.lg)),
            dayLabel.widthAnchor.constraint(equalToConstant: Constants.dayLabelWidth),

            forecastImage.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: Constants.space(.lg)),
            forecastImage.topAnchor.constraint(equalTo: dayLabel.topAnchor),
            forecastImage.widthAnchor.constraint(equalToConstant: Constants.forecastImageWidth),
            forecastImage.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),

            minTemperatureLabel.leadingAnchor.constraint(greaterThanOrEqualTo: forecastImage.trailingAnchor, constant: Constants.space(.lg)),
            minTemperatureLabel.topAnchor.constraint(equalTo: dayLabel.topAnchor),
            minTemperatureLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor),

            maxTemperatureLabel.leadingAnchor.constraint(equalTo: minTemperatureLabel.trailingAnchor, constant: Constants.space(.lg)),
            maxTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.space(.lg)),
            maxTemperatureLabel.topAnchor.constraint(equalTo: dayLabel.topAnchor),
            maxTemperatureLabel.bottomAnchor.constraint(equalTo: dayLabel.bottomAnchor)
        ])
    }
}
