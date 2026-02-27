//
//  WeatherModuleBuilder.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

protocol BuilderProtocol {
    func build() -> UIViewController
}

final class WeatherModuleBuilder: BuilderProtocol {

    private var coreNetwork: CoreNetworkServiceProtocol

    init(coreNetwork: CoreNetworkServiceProtocol) {
        self.coreNetwork = coreNetwork
    }

    func build() -> UIViewController {
        let presenter = Presenter()
        let interactor = Interactor(
            presenter: presenter,
            networkService: WeatherNetworkService(coreNetwork: coreNetwork),
            locationService: LocationService()
        )
        let vc = ViewController(interactor: interactor)
        presenter.viewController = vc
        return vc
    }
}
