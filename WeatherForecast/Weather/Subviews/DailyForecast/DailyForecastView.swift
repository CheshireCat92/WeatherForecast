//
//  DailyForecastView.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit
import Foundation

final class DailyForecastView: UIView {

    private enum Constants: DSSizes {
        static let interitemSpacing: CGFloat = 10
        static let itemHeight: CGFloat = 50
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .init(token: \.core.primary.surface)
        layer.cornerRadius = Constants.radius(.lg)
        layer.cornerCurve = .circular
        clipsToBounds = true

        let views = [
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView(),
            DailyForecastDayView()
        ]
        self.add(subviews: views)

        views.enumerated().forEach { pair in
            if pair.offset == 0 {
                NSLayoutConstraint.activate([
                    pair.element.topAnchor.constraint(equalTo: self.topAnchor),
                    pair.element.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    pair.element.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    pair.element.heightAnchor.constraint(equalToConstant: Constants.itemHeight)
                ])
            }else {
                let previousView = views[pair.offset - 1]
                guard views.last == pair.element else {
                    NSLayoutConstraint.activate([
                        pair.element.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.interitemSpacing),
                        pair.element.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                        pair.element.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                        pair.element.heightAnchor.constraint(equalToConstant: Constants.itemHeight)
                    ])
                    return
                }
                NSLayoutConstraint.activate([
                    pair.element.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.interitemSpacing),
                    pair.element.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    pair.element.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    pair.element.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    pair.element.heightAnchor.constraint(equalToConstant: Constants.itemHeight)
                ])
            }
        }
    }

    private func configure() { }
}


