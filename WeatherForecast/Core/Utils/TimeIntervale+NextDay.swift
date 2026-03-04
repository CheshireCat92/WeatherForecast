//
//  TimeIntervale+NextDay.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

extension Int {
    func isNextDayStart() -> Bool {
        let currentDate = Date.now
        let calendar = Calendar.current
        guard
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: currentDate),
            let tomorrowWithHours = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: tomorrow)
        else {
            return false
        }
        return tomorrowWithHours.timeIntervalSince1970.isEqual(to: TimeInterval(self))
    }
}
