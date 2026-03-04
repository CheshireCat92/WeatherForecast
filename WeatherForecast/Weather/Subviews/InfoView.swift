//
//  InfoView.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 04.03.2026.
//

import UIKit

final class InfoView: UIView {

    private enum Constants: DSSizes { }

    private lazy var text = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .dsFont(.bodyPrimary)
        label.textAlignment = .center
        return label
    }()

    private var currentState = InfoViewState.initial
    private var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .init(token: \.core.secondary.background)
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        layer.cornerRadius = Constants.radius(.xl)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onViewTap))
        addGestureRecognizer(recognizer)

        add(subview: text)

        NSLayoutConstraint.activate([
            text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.space(.sm)),
            text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.space(.sm)),
            text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.space(.sm))
        ])
    }

    @objc private func onViewTap() {
        switch currentState {
        case .error, .normal:
            onTap?()
        default:
            break
        }

    }

    func configureWith(_ model: InfoViewModel, onTap: @escaping (() -> Void)) {
        text.text = model.text
        currentState = model.state
        self.onTap = onTap
    }

}
