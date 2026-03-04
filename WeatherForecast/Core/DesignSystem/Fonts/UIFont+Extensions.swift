//
//  UIFont+Extensions.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//
import UIKit

extension UIFont {
    static func dsFont(_ type: DSFonts) -> UIFont {
        type.font()
    }
}
