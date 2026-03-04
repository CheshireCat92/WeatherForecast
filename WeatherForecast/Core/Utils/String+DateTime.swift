//
//  String+DateTime.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

extension String {
    func formatDateString(_ format: DateFormats = .yyyyMMddHHmm) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)
        guard let date = formatter.date(from: self) else { return nil }
        formatter.dateFormat = DateFormats.HHmm.rawValue
        let string = formatter.string(from: date)
        return string
    }

    func formatToLocalizedDay(_ format: DateFormats = .yyyyMMdd) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: .zero)
        guard let date = formatter.date(from: self) else { return nil }
        formatter.dateFormat = DateFormats.EEE.rawValue
        formatter.locale = Locale.prefferedLocale()
        formatter.timeZone = .autoupdatingCurrent
        let string = formatter.string(from: date)
        return string
    }
}
