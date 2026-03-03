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

    private lazy var contentView = ForecastContentView()


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
        setupUI()
    }

    private func setupUI() {
        view.add(subview: contentView)

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }


    // MARK: - Event handling
    private func fetchData() {
        Task {
            await interactor.fetchLocation()
        }
    }
    
    // For testing with current location
    private func fetchCurrentLocationWeather() {
        // Get current location using CLLocationManager
        // Then call fetchData with the coordinates
    }
}

extension ViewController: ViewControllerProtocol {
    func showError(message: String) {
        print("Error: \(message)")
    }

    func displayData(viewModel: String) {
        // Update the UI with the view model data
        print("Displaying weather data: \(viewModel)")
    }
}
