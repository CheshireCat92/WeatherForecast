//
//  HourlyForecastView.swift
//  WeatherForecast
//
//  Created by Artem Kovalev on 27.02.2026.
//

import UIKit
import Foundation

final class HourlyForecastView: UIView {

    private enum Constants: DSSizes {
        static let itemSize = CGSize(width: 80, height: 110)
    }

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = Constants.space(.sm)
        layout.itemSize = Constants.itemSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .init(token: \.core.secondary.background)
        collectionView.registerCell(HourlyForecastCollectionViewCell.self)
        return collectionView
    }()

    private var model =  HoursForecastViewModel(forecast: [HourViewModel]())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.add(subview: collectionView)
        backgroundColor = .init(token: \.core.secondary.background)
        layer.cornerRadius = Constants.radius(.xl)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.space(.md)),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor,  constant: -Constants.space(.md)),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.space(.md)),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.space(.md))
        ])
    }

    func configureWith(_ model: HoursForecastViewModel) {
        self.model = model
        collectionView.reloadData()
    }
}

extension HourlyForecastView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.forecast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: HourlyForecastCollectionViewCell = collectionView.dequeCell(indexPath: indexPath) else {
            return UICollectionViewCell(frame: .zero)
        }
        cell.configureWith(model.forecast[indexPath.row])
        return cell
    }

}


