//
//  String+DateTime.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

extension String {
    func formatDateString() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: self) else { return nil }
        formatter.dateFormat = "HH:mm"
        let string = formatter.string(from: date)
        return string
    }

    func formatToLocalizedDay() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: self) else { return nil }
        formatter.dateFormat = "EEE"
        formatter.locale = Locale.autoupdatingCurrent
        let string = formatter.string(from: date)
        return string
    }
}
