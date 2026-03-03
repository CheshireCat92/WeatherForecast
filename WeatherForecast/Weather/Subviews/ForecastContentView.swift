//
//  ForecastContentView.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 03.03.2026.
//

import UIKit

final class ForecastContentView: UIView {

    private enum Constants {
        static let scrollViewTopInset: CGFloat = 50
        static let currentPositionViewTopOffset: CGFloat = 50
        static let scrollGap: CGFloat = 20
        static let minScaleFactor = 0.8
        static let hourlyForecastViewHeight: CGFloat = 120
        static let currentPositionViewHeight: CGFloat = 95
    }

    private lazy var currentPositionView = CurrentPositionView()
    private lazy var hourlyForecastView = HourlyForecastView()
    private lazy var dailyForecastView = DailyForecastView()
    private lazy var contentView = UIView()
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.contentInset = .init(top: Constants.scrollViewTopInset, left: 0, bottom: 0, right: 0)
        view.bounces = false
        view.delegate = self
        return view
    }()

    private var currentPositionViewTopConstraint = NSLayoutConstraint()
    private var hourlyForecastViewTopConstraint = NSLayoutConstraint()
    private var dailyForecastViewTopConstraint = NSLayoutConstraint()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.add(subviews:[
            currentPositionView,
            scrollView
        ])

        scrollView.add(subviews: [
            contentView
        ])

        contentView.add(subviews: [
            hourlyForecastView,
            dailyForecastView
        ])

        currentPositionViewTopConstraint = currentPositionView.topAnchor.constraint(
            equalTo: topAnchor,
            constant: Constants.currentPositionViewTopOffset
        )

        hourlyForecastViewTopConstraint = hourlyForecastView.topAnchor.constraint(equalTo: contentView.topAnchor)

        dailyForecastViewTopConstraint = dailyForecastView.topAnchor.constraint(equalTo: hourlyForecastView.bottomAnchor)

        NSLayoutConstraint.activate([
            currentPositionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            currentPositionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            currentPositionViewTopConstraint,
            currentPositionView.heightAnchor.constraint(equalToConstant: Constants.currentPositionViewHeight),

            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: currentPositionView.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),


            hourlyForecastView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor),
            hourlyForecastView.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor),
            hourlyForecastViewTopConstraint,
            hourlyForecastView.heightAnchor.constraint(equalToConstant: Constants.hourlyForecastViewHeight),
            hourlyForecastView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            dailyForecastView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dailyForecastView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dailyForecastViewTopConstraint,
            dailyForecastView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

extension ForecastContentView: UIScrollViewDelegate {
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
            normalVelocity != .zero
        else { return }

        let duration = abs(expectedYOffset - scrollView.contentOffset.y.rounded()) / normalVelocity  / 1000
        scrollView.setContentOffset(scrollView.contentOffset, animated: false)

        UIView.animate(withDuration: duration, delay: .zero, options: [.layoutSubviews]) {
            scrollView.setContentOffset(expectedPoint, animated: false)
            self.currentPositionViewTopConstraint.constant = Constants.currentPositionViewTopOffset
            self.hourlyForecastView.transform = CGAffineTransform.identity
            self.hourlyForecastViewTopConstraint.constant = .zero
            self.dailyForecastViewTopConstraint.constant = .zero
            self.hourlyForecastView.alpha = 1
            self.layoutIfNeeded()
        }
    }



    private func animateTopConstraint(_ offset: Double) {
        guard offset < .zero else { return }
        currentPositionViewTopConstraint.constant = -offset
    }

    private func animateHourlyBlock(_ offset: Double) {
        guard offset >= .zero else { return }
        let percentage = (100 - (offset * 100 / hourlyForecastView.frame.height).rounded()) / 100
        if percentage >= Constants.minScaleFactor {
            hourlyForecastView.transform = CGAffineTransformMakeScale(percentage, percentage)
        }

        guard percentage >= .zero else { return }
        hourlyForecastViewTopConstraint.constant = offset
        dailyForecastViewTopConstraint.constant = -offset
        hourlyForecastView.alpha = percentage
    }
}
