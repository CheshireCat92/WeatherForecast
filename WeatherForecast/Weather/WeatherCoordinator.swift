//
//  Coordinator.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

final class WeatherCoordinator: BaseCoordinator {
    private let coreNetwork: CoreNetworkServiceProtocol

    init(
        coreNetwork: CoreNetworkServiceProtocol,
        cordinatorBuilder: any CoordinatorBuilderProtocol,
        navigationController: UINavigationController,
        parentCoordinator: (any Coordinator)? = nil
    ) {
        self.coreNetwork = coreNetwork
        super.init(cordinatorBuilder: cordinatorBuilder, navigationController: navigationController, parentCoordinator: parentCoordinator)
    }

    override func start() {
        let vc = WeatherModuleBuilder(coreNetwork: coreNetwork).build()
        navigationController.pushViewController(vc, animated: false)
    }
}
