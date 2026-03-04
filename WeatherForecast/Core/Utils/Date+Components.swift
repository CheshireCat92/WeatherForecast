//
//  Date+.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

extension Date {
    func timeStampWithComponents(_ components: Set<Calendar.Component>) -> TimeInterval? {
        let calendar = Calendar.current
        let components = calendar.dateComponents(components, from: self)
        return calendar.date(from: components)?.timeIntervalSince1970
    }

    func dateWithComponents(_ components: Set<Calendar.Component>) -> Date? {
        let calendar = Calendar.current
        let components = calendar.dateComponents(components, from: self)
        return calendar.date(from: components)
    }

}
