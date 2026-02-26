//
//  CoordinatorBuilder.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

protocol CoordinatorBuilderProtocol {
    func buildForecastCoordinator(parent: Coordinator?) -> Coordinator
}

final class CoordinatorBuilder: CoordinatorBuilderProtocol {
    private let coreNetwork = CoreNetworkService()

    func buildAppCoordinator() -> Coordinator {
        AppCoordinator(cordinatorBuilder: self, navigationController: UINavigationController())
    }

    func buildForecastCoordinator(parent: Coordinator? = nil) -> Coordinator {
        let parentNC = parent?.navigationController ?? UINavigationController()
        return WeatherCoordinator(
            coreNetwork: coreNetwork,
            cordinatorBuilder: self,
            navigationController: parentNC,
            parentCoordinator: parent
        )
    }
}
