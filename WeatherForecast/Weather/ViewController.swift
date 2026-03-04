//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 26.02.2026.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    func showError(message: String) async
    func displayData(viewModel: ForecastViewModel) async
    func displayInfoData(viewModel: InfoViewModel) async
}

final class ViewController: UIViewController {

    private enum Constants {
        static let infoViewHeight: CGFloat = 30
    }

    private var interactor: InteractorProtocol

    private lazy var contentView = ForecastContentView()
    private lazy var infoView = InfoView()


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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchData()
    }

    private func setupUI() {
        view.add(subviews:[contentView, infoView])
        view.backgroundColor = .init(token: \.core.primary.background)

        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.infoViewHeight),

            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }

    private func fetchData() {
        Task {
            await interactor.fetchLocation()
        }
    }
}

extension ViewController: ViewControllerProtocol {

    @MainActor
    func displayInfoData(viewModel: InfoViewModel) {
        infoView.configureWith(viewModel) { [weak self] in
            guard let self else { return }
            self.fetchData()
        }
    }

    @MainActor
    func displayData(viewModel: ForecastViewModel) {
        contentView.configureWith(viewModel)
    }

    @MainActor
    func showError(message: String) {
        print("Error: \(message)")
    }
}
