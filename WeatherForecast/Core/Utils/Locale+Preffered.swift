//
//  Locale+Preffered.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

extension Locale {
    static func prefferedLocale() -> Locale {
        guard let lang = Locale.preferredLanguages.first else { return .autoupdatingCurrent}
        return Locale(identifier: lang)
    }
}
