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

    private enum Constants {
        static let scrollViewTopInset: CGFloat = 50
        static let currentPositionViewTopOffset: CGFloat = 50
        static let hourlyForecastViewTopOffset: CGFloat = 0
        static let scrollGap: CGFloat = 20
    }

    private var interactor: InteractorProtocol
    private let animator = UIViewPropertyAnimator()

    private lazy var currentPositionView = CurrentPositionView()
    private lazy var hourlyForecastView = HourlyForecastView()
    private lazy var dailyForecastView = DailyForecastView()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: 50, left: 0, bottom: 0, right: 0)
        view.bounces = false
        return view
    }()
    private lazy var contentView = UIView()

    private var currentPositionViewTopConstraint = NSLayoutConstraint()
    private var hourlyForecastViewTopConstraint = NSLayoutConstraint()
    private var dailyForecastViewTopConstraint = NSLayoutConstraint()

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
        view.add(subviews:[
            currentPositionView,
            scrollView
        ])

        scrollView.delegate = self

        scrollView.add(subviews: [
            contentView
        ])

        contentView.add(subviews: [
            hourlyForecastView,
            dailyForecastView
        ])

        currentPositionViewTopConstraint = currentPositionView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: Constants.currentPositionViewTopOffset
        )

        hourlyForecastViewTopConstraint = hourlyForecastView.topAnchor.constraint(
            equalTo: contentView.topAnchor,
            constant: Constants.hourlyForecastViewTopOffset
        )

        dailyForecastViewTopConstraint = dailyForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor)

        NSLayoutConstraint.activate([
            currentPositionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            currentPositionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            currentPositionViewTopConstraint,
            currentPositionView.heightAnchor.constraint(equalToConstant: 95),

            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: currentPositionView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),


            hourlyForecastView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor),
            hourlyForecastViewTopConstraint,
            hourlyForecastView.heightAnchor.constraint(equalToConstant: 120),
            hourlyForecastView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            dailyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dailyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dailyForecastViewTopConstraint,
            dailyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animator.addAnimations {
            self.view.layoutIfNeeded()
        }
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

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        animateTopConstraint(scrollView.contentOffset.y)
        animateHourlyBlock(scrollView.contentOffset.y)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let expectedPoint = targetContentOffset.pointee
        let expectedYOffset = expectedPoint.y.rounded()
        let normalVelocity = abs(velocity.y.rounded())

        guard
            (expectedYOffset + Constants.scrollViewTopInset) <= Constants.scrollGap,
            normalVelocity != 0.0
        else { return }

        let duration = abs(expectedYOffset - scrollView.contentOffset.y.rounded()) / normalVelocity  / 1000
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)

        UIView.animate(withDuration: duration, delay: 0, options: [.layoutSubviews]) {
            scrollView.setContentOffset(expectedPoint, animated: false)
            self.currentPositionViewTopConstraint.constant = Constants.currentPositionViewTopOffset
            self.hourlyForecastView.transform = CGAffineTransform.identity
            self.hourlyForecastViewTopConstraint.constant = Constants.hourlyForecastViewTopOffset
            self.dailyForecastViewTopConstraint.constant = 0
            self.hourlyForecastView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }



    private func animateTopConstraint(_ offset: Double) {
        guard offset < 0 else { return }
        currentPositionViewTopConstraint.constant = -offset
        animator.fractionComplete = offset
    }

    private func animateHourlyBlock(_ offset: Double) {
        guard offset >= 0 else { return }
        let percentage = (100 - (offset * 100 / hourlyForecastView.frame.height).rounded()) / 100
        if percentage >= 0.8 {
            hourlyForecastView.transform = CGAffineTransformMakeScale(percentage, percentage)
        }

        guard percentage >= 0 else { return }
        hourlyForecastViewTopConstraint.constant = offset
        dailyForecastViewTopConstraint.constant = -offset
        hourlyForecastView.alpha = percentage
        animator.fractionComplete = percentage
    }
}
