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

    private lazy var testButton = UIButton(frame: .zero)

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
        view.addSubview(testButton)
        testButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            testButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            testButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            testButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        testButton.backgroundColor = .red
        testButton.addAction(UIAction { [weak self] _ in
            self?.fetchData()
        }, for: .touchUpInside)
    }



    // MARK: - Event handling
    private func fetchData() {
//        Task {
//            await interactor.fetchData(lat: "51.5085", lon: "0.1257") // London coordinates
//        }
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
