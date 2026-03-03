//
//  DailyForecastCollectionViewCell.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit

final class DailyForecastCollectionViewCell: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .blue
    }
}
