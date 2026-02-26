//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import Foundation

final class WeatherCoordinator: BaseCoordinator {

    override func start() {
        let vc = WeatherModuleBuilder().build()
        navigationController.pushViewController(vc, animated: false)
    }
}
