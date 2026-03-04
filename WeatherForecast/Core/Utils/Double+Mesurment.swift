//
//  Double+Mesurment.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

extension Double {
    func formatToMesurment(_ type: UnitTemperature, fractionDigits: Int = .zero) -> String {
        let unit = Measurement(value: self, unit: type)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.numberFormatter.maximumFractionDigits = fractionDigits
        return formatter.string(from: unit)
    }
}
