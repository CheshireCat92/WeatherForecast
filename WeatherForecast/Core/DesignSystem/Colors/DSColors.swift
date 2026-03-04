//
//  DSColors.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import UIKit

struct Primary {
    let background = "#f9f5f9"
    let surface = "#FFFFFF"
    let accent = "#007AFF"
    let text = "#111827"
}

struct Secondary {
    let text = "#6B7280"
    let background = "#e9e6ed"
}

struct Core {
    let primary = Primary()
    let secondary = Secondary()
    let divider = "#E5E7EB"
}

struct Temp {
    let min = "#34C759"
    let max = "#FF9500"
}

struct State {
    let activeBg = "#007AFF"
    let activeText = "#FFFFFF"
}

struct Semantic {
    let state = State()
    let temp = Temp()
}

struct DSColors {
    let core = Core()
    let semantic = Semantic()
}
