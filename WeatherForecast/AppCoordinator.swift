//
//  AppCoordinator.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

    override func start() {
        let coordinator = self.cordinatorBuilder.buildForecastCoordinator(parent: self)
        runChildCoordinator(coordinator)
    }
}
