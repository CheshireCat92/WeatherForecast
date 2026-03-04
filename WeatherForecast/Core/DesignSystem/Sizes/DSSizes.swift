//
//  DSSizes.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import Foundation

protocol DSSizes {}

extension DSSizes {
    static func radius(_ type: DSRadiuses) -> CGFloat {
        type.rawValue
    }

    static func space(_ type: DSSpaces) -> CGFloat {
        type.rawValue
    }
}
