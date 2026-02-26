//
//  BaseCoordinator.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

protocol Coordinator {
    var cordinatorBuilder: CoordinatorBuilderProtocol { get }
    var childCoordinators: [Coordinator] { get }
    var navigationController: UINavigationController { get }
    var parentCoordinator: Coordinator? { get }
    func start()
}

class BaseCoordinator: Coordinator {
    private(set) var cordinatorBuilder: CoordinatorBuilderProtocol
    private(set) var childCoordinators = [Coordinator]()
    private(set) var navigationController: UINavigationController
    private(set) var parentCoordinator: Coordinator?

    init(
        cordinatorBuilder: CoordinatorBuilderProtocol,
        navigationController: UINavigationController,
        parentCoordinator: Coordinator? = nil
    ) {
        self.cordinatorBuilder = cordinatorBuilder
        self.navigationController = navigationController
        self.parentCoordinator = parentCoordinator
    }

    func start() { }

    func runChildCoordinator(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
