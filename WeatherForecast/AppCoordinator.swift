//
//  AppCoordinator.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    convenience init(parentCoordinator: Coordinator? = nil) {
        self.init(navigationController: UINavigationController())
    }

    override func start() {
        let coordinator = WeatherCoordinator(navigationController: self.navigationController, parentCoordinator: self)
        runChildCoordinator(coordinator)
    }
}
