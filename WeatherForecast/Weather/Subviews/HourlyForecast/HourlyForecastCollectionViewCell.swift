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
        return label
    }()

    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var forecastImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        forecastImage.image = nil
        temperatureLabel.text = nil
        timeLable.text = nil
        temperatureLabel.textColor = .black
        timeLable.textColor = .black
        backgroundColor = .white
    }

    private func setupUI() {
        backgroundColor = .init(token: \.core.primary.surface)
        layer.cornerRadius = Constants.radius(.lg)
        layer.cornerCurve = .circular

        let stack = UIStackView()
        stack.alignment = .center
        stack.distribution = .fillProportionally
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

    func configureWith(_ model: HourViewModel) {
        timeLable.text = model.time
        temperatureLabel.text = model.temperature
        forecastImage.kf.setImage(with: model.imageURL)
        if model.isNow || model.isNextDayStart {
            temperatureLabel.textColor = .init(token: \.semantic.state.activeText)
            timeLable.textColor = .init(token: \.semantic.state.activeText)
            backgroundColor = .init(token: \.core.primary.accent)
        } else {
            temperatureLabel.textColor = .black
            timeLable.textColor = .black
            backgroundColor = .init(token: \.core.primary.surface)
        }
    }

}
