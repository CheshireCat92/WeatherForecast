//
//  Interactor.swift
//  WeatherForecast
//
//  Created on $CURRENT_DATE.
//

import Foundation

protocol InteractorProtocol: AnyObject {

}

final class Interactor {
    // MARK: - Types
    
    // MARK: - Properties
    private var presenter: PresenterProtocol

    init(presenter: PresenterProtocol) {
        self.presenter = presenter
    }

    // MARK: - Business logic
    func fetchData() {
        // Business logic here
    }
}

extension Interactor: InteractorProtocol {

}
