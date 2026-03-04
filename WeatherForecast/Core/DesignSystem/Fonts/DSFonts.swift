//
//  DSFonts.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import UIKit

enum DSFonts {
    case displayTemp, titleCity, sectionTitle
    case bodyPrimary, bodySmall
    case captionHour, tempHour

    func font() -> UIFont {
        switch self {
        case .displayTemp:
                .systemFont(ofSize: 64, weight: .bold)
        case .titleCity:
                .systemFont(ofSize: 22, weight: .semibold)
        case .sectionTitle:
                .systemFont(ofSize: 17, weight: .semibold)
        case .bodyPrimary:
                .systemFont(ofSize: 16, weight: .regular)
        case .bodySmall:
                .systemFont(ofSize: 14, weight: .regular)
        case .captionHour:
                .systemFont(ofSize: 13, weight: .medium)
        case .tempHour:
                .systemFont(ofSize: 18, weight: .semibold)
        }
    }
}

