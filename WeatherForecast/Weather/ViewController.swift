//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    func showError(message: String)
    func displayData(viewModel: String)
}

final class ViewController: UIViewController {

    private var interactor: InteractorProtocol

    init(interactor: InteractorProtocol) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchData()
    }
    
    // MARK: - Event handling
    private func fetchData() {
        Task {
            await interactor.fetchData(lat: "51.5085", lon: "0.1257") // London coordinates
        }
    }
    
    // For testing with current location
    private func fetchCurrentLocationWeather() {
        // Get current location using CLLocationManager
        // Then call fetchData with the coordinates
    }
    
    // MARK: - Display
    func displayData(viewModel: String) {
        // Update the UI with the view model data
        print("Displaying weather data: \(viewModel)")
    }
}

extension ViewController: ViewControllerProtocol {
    func showError(message: String) {
        print("Error: \(message)")
    }
}
