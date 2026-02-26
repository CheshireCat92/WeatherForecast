//
//  Presenter.swift
//  WeatherForecast
//
//  Created on $CURRENT_DATE.
//

import Foundation

protocol PresenterProtocol {

}

final class Presenter {
    // MARK: - Types
    
    // MARK: - Properties
    weak var viewController: ViewControllerProtocol?

    // MARK: - Presentation logic
    func presentData() {
        // Format the data for display
    }
}

extension Presenter: PresenterProtocol {
    
}
